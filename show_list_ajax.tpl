<html>
<head>
  <title>Todo List 0.001</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
  <link href="https://www.w3schools.com/w3css/4/w3.css" rel="stylesheet" />
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script>
  $(document).ready(function() {

    function buildData () {
        const searchFilterText = $('#search-box').val();
        $.getJSON("/get_tasks", function(rows) {
            const table = $("<table/>")
                .addClass("w3-table w3-bordered w3-border")
                .appendTo("#content");
            $.each(rows, function(i, row) {
                const taskText = row["task"];
                if (searchFilterText == "" || taskText.includes(searchFilterText)) {
                    const tableRow = $("<tr/>");
                    const tableData1 = $("<td/>")
                        .html(`<a href="/update_task/${row["id"]}"><i class="material-icons">edit</i></a>`);
                    const tableData2 = $("<td/>").html(taskText);
                    const tableData3 = $("<td/>")
                        .html(`<a href="/update_status/${row["id"]}/${row["status"] ^ 1}"><i class="material-icons">${row["status"] ? "check_box" : "check_box_outline_blank"}</i></a>`);
                    const tableData4 = $("<td/>")
                        .html(`<a href="/delete_item/${row["id"]}"><i class="material-icons">delete</i></a>`);
                    tableRow.append(tableData1, tableData2, tableData3, tableData4);
                    table.append(tableRow);
                }
            });
        });
    }

    function resetData() {
        $("#content").empty();
    }

    // reference to https://gist.github.com/beaucharman/1f93fdd7c72860736643d1ab274fee1a
    // native es6 debounce (without something like lodash)
    function debounce (fn, wait) {
        let t
        return function () {
            clearTimeout(t)
            t = setTimeout(() => fn.apply(this, arguments), wait)
        }
    }

    $('#search-box').change( debounce(function(){
        resetData();
        buildData();
    }, 200));

    $('.filter-ctn').click( async function() {
        const { filter_finished }  = await fetch('/setFilterCookie', { method: 'POST' }).then(response => response.json());
        $(".filter-ctn").html(`<i class="material-icons"> ${ filter_finished ? "check_box" : "check_box_outline_blank" }</i>`);
        resetData();
        buildData();
    });

    $('#task-btn').click( async function() {
        const task = $('#task-value').val();
        if (task !== '') {
            const formData = new FormData();
            formData.append('new_task', task);
            await fetch('/new_item', {
                method: 'POST',
                body: formData
            });
            $('#task-value').val('');
            resetData();
            buildData();
        }
    });

    buildData();
    
  })
  </script>
</head>
<body>
%include("header.tpl", session=session)
%include("new_item_ajax.tpl")
<hr />
<div class="filter" style="
    display: flex;
    justify-content: center;
">
    <input id="search-box" type="text" placeholder="Type to search and filter" style="
        align-self: center;
        flex-basis: 50%;"
    />
    <ul>
        <li style="
            display: flex;
            align-items: center;
            list-style: none;
        ">Remove Finished tasks 
            <span class="filter-ctn" style="padding-left: 1em;">
                <i class="material-icons"> {{ "check_box" if filterFinished else "check_box_outline_blank" }}</i>
            </span>
        </li>
    </ul>
</div>
<hr />
<div id="content"></div>
%include("footer.tpl", session=session)
</body>
</html>