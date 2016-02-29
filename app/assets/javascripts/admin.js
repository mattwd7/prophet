$(document).ready(function(){

    $('.sort div').click(function(){
        if ($(this).hasClass('admin')){
            $('.column').hide();
            $('#admin-grid_wrapper').show();
            initAdmin();
        } else {
            $('.column').show();
            $('#admin-grid_wrapper').hide();
        }
    });

//    ENABLED ONLY FOR DEV TESTING
//    $('.column').hide();
//    initAdmin();


    var users;
    var grid = $('#admin-grid');
    function initAdmin(){
        if (!grid.hasClass('initialized')) {
            $.ajax({
                method: 'get',
                url: '/organizations/get_users',
                success: function (data) {
                    users = data;
                    initGrid(data);
                }
            })
        }
    }

    function initGrid(users){
        for (var i = 0; i < users.length; i++){
            var user = users[i];
            grid.append(userRow(user));
        }
        grid.DataTable({
            'order': [[ 1, "asc" ], [ 0, "asc" ]],
            'paging': false
        });
        grid.addClass('initialized');
    }

    function userRow(user){
        return  "<tr><td>" + user.first_name + "</td>" +
                "<td>" + user.last_name + "</td>" +
                "<td>" + user.user_tag + "</td>" +
                "<td>" + user.email + "</td>" +
                "<td>" + user.manager + "</td></tr>";
    };

});

