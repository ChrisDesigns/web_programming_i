<h3 class="w3-block w3-grey w3-center" style="margin: 0;">Basic Todo List, version 1.1</h3>
<div class="w3-bar w3-teal">
  % if 'username' in session and session['username'] != 'Guest':
      <a href="/logout"><button class="w3-bar-item w3-button">Logout</button></a>
  % else:
      <a href="/login"><button class="w3-bar-item w3-button">Login</button></a>
  % end
  <a href="/new_item"><button class="w3-bar-item w3-button">New item...</button></a>
</div>