$(document).ready(function(){
//
    $('.sort div').click(function(){
        if ($(this).hasClass('admin')){
            $('.column').hide();
            initAdmin();
        } else {
            $('.column').show();
        }
    });

    // remove these later
//    $('.column').hide();
//    initAdmin();


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
            {id: "first_name", name: "First Name", field: "first_name", width: 160},
            {id: "last_name", name: "Last Name", field: "last_name", width: 200},
            {id: "user_tag", name: "User Tag", field: "user_tag", width: 200},
            {id: "email", name: "Email", field: "email", width: 240},
            {id: "manager", name: "Manager", field: "manager", width: 200}
        ];
        var options = {
            enableCellNavigation: true,
            enableColumnReorder: false,
            autoHeight: true
        };
        var data = [];
        for (var i = 0; i < users.length; i++) {
            data[i] = {
                first_name: users[i].first_name,
                last_name: users[i].last_name,
                user_tag: users[i].user_tag,
                email: users[i].email,
                manager: users[i].manager
            };
        }
        grid = new Slick.Grid("#admin-grid", data, columns, options);

    }
});

