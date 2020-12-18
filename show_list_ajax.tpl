<html>
<head>
  <title>Todo List 0.001</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
  <link href="https://www.w3schools.com/w3css/4/w3.css" rel="stylesheet" />
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script>
  $(document).ready(function() {

    function buildData () {
        $.getJSON("/get_tasks", function(rows) {
            const table = $("<table/>")
                .addClass("w3-table w3-bordered w3-border")
                .appendTo("#content");
            $.each(rows, function(i, row) {
                const tableRow = $("<tr/>");
                const tableData1 = $("<td/>")
                    .html(`<a href="/update_task/${row["id"]}"><i class="material-icons">edit</i></a>`);
                const tableData2 = $("<td/>").html(row["task"]);
                const tableData3 = $("<td/>")
                    .html(`<a href="/update_status/${row["id"]}/${row["status"] ^ 1}"><i class="material-icons">${row["status"] ? "check_box" : "check_box_outline_blank"}</i></a>`);
                const tableData4 = $("<td/>")
                    .html(`<a href="/delete_item/${row["id"]}"><i class="material-icons">delete</i></a>`);
                tableRow.append(tableData1, tableData2, tableData3, tableData4);
                table.append(tableRow);
            });
        });
    }

    function resetData() {
        $("#content").empty();
    }

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
<div id="content"></div>
%include("footer.tpl", session=session)
</body>
</html>