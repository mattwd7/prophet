$(document).ready(function(){

    $('.sort div').click(function(){
        if ($(this).hasClass('admin')){
            $('.column').hide();
            initAdmin();
        } else {
            $('.column').show();
        }
    });

    // remove these later
    $('.column').hide();
    initAdmin();


    var users;
    var grid = $('#admin-grid');
    function initAdmin(){
        $.ajax({
            method: 'get',
            url: '/organizations/get_users',
            success: function(data){
                users = data;
                for (var i = 0; i < users.length; i++){
                    var user = users[i];
                    grid.find('tbody').append(userRow(user));
                }
                initGrid(data);
            }
        })
    }

    function initGrid(users){
//        for (var i = 0; i < users.length; i++){
//            var user = users[i];
//            grid.append(userRow(user));
//        }
        grid.DataTable({
            "order": [[ 1, "asc" ], [ 0, "asc" ]]
        });
    }

    function userRow(user){
        return  "<tr><td>" + user.first_name + "</td>" +
                "<td>" + user.last_name + "</td>" +
                "<td>" + user.user_tag + "</td>" +
                "<td>" + user.email + "</td>" +
                "<td>" + user.manager + "</td></tr>";
    };

//    function initGrid(){
//        var grid;
//        var columns = [
//            {id: "first_name", name: "First Name", field: "first_name", width: 160},
//            {id: "last_name", name: "Last Name", field: "last_name", width: 200},
//            {id: "user_tag", name: "User Tag", field: "user_tag", width: 200},
//            {id: "email", name: "Email", field: "email", width: 240},
//            {id: "manager", name: "Manager", field: "manager", width: 200}
//        ];
//        var options = {
//            enableCellNavigation: true,
//            enableColumnReorder: false,
//            autoHeight: true
//        };
//        var data = [];
//        for (var i = 0; i < users.length; i++) {
//            data[i] = {
//                first_name: users[i].first_name,
//                last_name: users[i].last_name,
//                user_tag: users[i].user_tag,
//                email: users[i].email,
//                manager: users[i].manager
//            };
//        }
//        grid = new Slick.Grid("#admin-grid", data, columns, options);
//
//    }

});

