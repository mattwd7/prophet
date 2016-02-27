$(document).ready(function(){

    $('.sort div').click(function(){
        if ($(this).hasClass('admin')){
            $('.column').hide();
            initAdmin();
        } else {
            $('.column').show();
        }
    });

    var users;
    function initAdmin(){
        $.ajax({
            method: 'get',
            url: '/organizations/get_users',
            success: function(data){
                users = data;
                initGrid();
            }
        })
    }

    function initGrid(){
        var grid;
        var columns = [
            {id: "title", name: "Title", field: "title"},
            {id: "duration", name: "Duration", field: "duration"},
            {id: "%", name: "% Complete", field: "percentComplete"},
            {id: "start", name: "Start", field: "start"},
            {id: "finish", name: "Finish", field: "finish"},
            {id: "effort-driven", name: "Effort Driven", field: "effortDriven"}
        ];
        var options = {
            enableCellNavigation: true,
            enableColumnReorder: false
        };
        var data = [];
        for (var i = 0; i < 5; i++) {
            var d = (data[i] = {});
            d["title"] = "<a href='#' tabindex='0'>Task</a> " + i;
            d["duration"] = "5 days";
            d["percentComplete"] = Math.min(100, Math.round(Math.random() * 110));
            d["start"] = "01/01/2009";
            d["finish"] = "01/05/2009";
            d["effortDriven"] = (i % 5 == 0);
        }
        console.log(data);
        grid = new Slick.Grid("#admin-grid", data, columns, options);
        grid.init();
    }

//    function initGrid(){
//        var grid;
//        var columns = [
//            {id: "first_name", name: "First Name", field: "first_name"},
//            {id: "last_name", name: "Last Name", field: "last_name"},
//            {id: "user_tag", name: "User Tag", field: "user_tag"},
//            {id: "email", name: "Email", field: "email"}
//        ];
//        var options = {
//            enableCellNavigation: true,
//            enableColumnReorder: false
//        };
//        var data = [];
//        for (var i = 0; i < users.length; i++) {
//            data[i] = {
//                first_name: users[i].first_name,
//                last_name: users[i].last_name,
//                user_tag: users[i].user_tag,
//                email: users[i].email
//            };
//        }
//        grid = new Slick.Grid("#admin-grid", data, columns, options);
//
//    }
});