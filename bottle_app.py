import os
import datetime
import time
import uuid
import dataset
import pymongo
import bcrypt
from bson.objectid import ObjectId
from bson.json_util import dumps


client = pymongo.MongoClient("mongodb://127.0.0.1:27017/todo?retryWrites=true&w=majority",
                             connectTimeoutMS=30000,
                             socketTimeoutMS=None,
                             # socketKeepAlive=True,
                             connect=False, maxPoolsize=1)

db = client.todo

from bottle import get, post, request, response, template, redirect

ON_PYTHONANYWHERE = "PYTHONANYWHERE_DOMAIN" in os.environ.keys()

if ON_PYTHONANYWHERE:
    from bottle import default_app 
else:
    from bottle import run, debug


def get_session(request, response):
    session_id = request.cookies.get("session_id",None)
    if session_id == None:
        session_id = str(uuid.uuid4())
        session = { 'session_id':session_id, "username":"Guest", "time":int(time.time()) }
        db.session.insert_one(session)
        response.set_cookie("session_id",session_id)
    else:
        session = db.session.find_one( {"session_id": session_id} )
        if session == None:
            session_id = str(uuid.uuid4())
            session = { 'session_id':session_id, "username":"Guest", "time":int(time.time()) }
            db.session.insert_one(session)
            response.set_cookie("session_id",session_id)

            # session = {"message":"no session found with the id =" + session_id}
    return session

def save_session(session):
    db.session.find_one_and_update(
    {"session_id" : session['session_id']},
    {"$set":
        {"username": session['username']}
    })

@get('/login')
def get_login():
    session = get_session(request, response)
    if session['username'] != 'Guest':
        redirect('/')
        return
    return template("login", session=session, csrf_token="abcrsrerredadfa")

@post('/login')
def post_login():
    session = get_session(request, response)
    if session['username'] != 'Guest':
        redirect('/')
        return
    # csrf_token = request.forms.get("csrf_token").strip()
    # if csrf_token != "abcrsrerredadfa":
    #     redirect('/login_error')
    #     return
    username = request.forms.get("username").strip()
    password = request.forms.get("password").strip().encode("utf-8")
    profile = db.profile.find_one( {"username": username} )
    if profile == None:
        redirect('/login_error')
        return
    if not bcrypt.checkpw(password, profile["password"]):
        redirect('/login_error')
        return
    session['username'] = username
    save_session(session)
    redirect('/')


@get('/logout')
def get_logout():
    session = get_session(request, response)
    session['username'] = 'Guest'
    save_session(session)
    redirect('/login')

@get('/register')
def get_register():
    session = get_session(request, response)
    if session['username'] != 'Guest':
        redirect('/')
        return
    return template("register", session=session, csrf_token="abcrsrerredadfa")

@post('/register')
def post_register():
    session = get_session(request, response)
    if session['username'] != 'Guest':
        redirect('/')
        return
    # csrf_token = request.forms.get("csrf_token").strip()
    # if csrf_token != "abcrsrerredadfa":
    #     redirect('/login_error')
    #     return
    username = request.forms.get("username").strip()
    password = request.forms.get("password").strip().encode("utf-8")
    passwordHashed = bcrypt.hashpw(password, bcrypt.gensalt())

    if len(password) < 8:
        redirect('/login_error')
        return
    profile = db.profile.find_one( {"username": username} )
    if profile:
        redirect('/login_error')
        return
    db.profile.insert_one({'username':username, 'password':passwordHashed})
    redirect('/')


@get('/show_list')
def get_show_list():
    session = get_session(request, response)
    if session['username'] == 'Guest':
        redirect('/login')
        return
    result = db.task.find()
    result=[dict(r) for r in result]
    return template("show_list", rows=result, session=session)

@get('/')
def get_show_list_ajax():
    session = get_session(request, response)
    filterFinished = bool(int(request.cookies.get("filter_finished", False)))
    if session['username'] == 'Guest':
        redirect('/login')
        return
    return template("show_list_ajax", session=session, filterFinished=filterFinished)

@post('/setFilterCookie')
def set_filter_cookie():
    session = get_session(request, response)
    response.content_type = 'application/json'
    if session['username'] == 'Guest':
        return "[]"
    previousValue = int(request.cookies.get("filter_finished", 1))
    newValue = previousValue ^ 1
    response.set_cookie("filter_finished", str(newValue), path='/')
    return dumps(dict({'filter_finished': bool(newValue)}))

@get('/get_tasks')
def get_get_tasks():
    session = get_session(request, response)
    response.content_type = 'application/json'
    if session['username'] == 'Guest':
        return "[]"
    else:
        filterFinished = bool(int(request.cookies.get("filter_finished", False)))
        result = []
        if (filterFinished):
            result = db.task.find({'status': False})
        else:
            result = db.task.find()

        tasks = [dict(r) for r in result]
        text = dumps(tasks)
        return text

@get('/update_status/<_id>/<value:int>')
def get_update_status(_id, value):
    session = get_session(request, response)
    if session['username'] == 'Guest':
        redirect('/login')
        return
    result = db.task.update_one( {"_id" : ObjectId(_id)}, {'$set': {'status': (value!=0)}} )
    redirect('/')


@get('/delete_item/<_id>')
def get_delete_item(_id):
    session = get_session(request, response)
    if session['username'] == 'Guest':
        redirect('/login')
        return
    # given an id, delete the relevant document
    result = db.task.delete_one( {"_id": ObjectId(_id)} )
    redirect('/')

@get('/delete/all')
def get_delete_all():
    session = get_session(request, response)
    if session['username'] == 'Guest':
        redirect('/login')
        return
    db.task.drop()
    redirect('/')


@get('/update_task/<_id>')
def get_update_task(_id):
    session = get_session(request, response)
    if session['username'] == 'Guest':
        redirect('/login')
        return
    # given an id, get the document and populate a form
    result = db.task.find_one( {"_id": ObjectId(_id)} )
    return template("update_task", row=dict(result))

@post('/update_task')
def post_update_task():
    session = get_session(request, response)
    if session['username'] == 'Guest':
        redirect('/login')
        return
    # given an id and an updated task in a form, find the document and modify the task value
    _id = request.forms.get("_id").strip()
    updated_task = request.forms.get("updated_task").strip()
    result = db.task.update_one( {"_id" : ObjectId(_id)}, {'$set': {'task': updated_task}} )
    redirect('/')


@get('/new_item')
def get_new_item():
    session = get_session(request, response)
    if session['username'] == 'Guest':
        redirect('/login')
        return
    return template("new_item")


@post('/new_item')
def post_new_item():
    session = get_session(request, response)
    if session['username'] == 'Guest':
        redirect('/login')
        return
    new_task = request.forms.get("new_task").strip()
    db.task.insert_one({'task':new_task, 'status':False})
    redirect('/')



if __name__ == "__main__":
    if ON_PYTHONANYWHERE:
        application = default_app()
    else:
        debug(True)
        run(host="localhost", port=8080)