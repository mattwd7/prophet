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

        // Use .each() to allow for proper $(this) scope
        $('#admin-grid_wrapper').find('.inline-editable').each(function(){
            $(this).editable('organizations/update_user', {
                method: 'PUT',
                onblur: 'submit',
                submitdata: { id: $(this).closest('tr').attr('user_id'), attribute: $(this).closest('td').attr('user_attribute') },
                data: function(string){ return $.trim(string); }
            });
        });

        grid.addClass('initialized');
    }

    function userRow(user){
        return  "<tr user_id=" + user.id + "><td user_attribute='first_name' class='inline-editable'>" + user.first_name + "</td>" +
                "<td user_attribute='last_name' class='inline-editable'>" + user.last_name + "</td>" +
                "<td user_attribute='user_tag'>" + user.user_tag + "</td>" +
                "<td user_attribute='email' class='inline-editable'>" + user.email + "</td>" +
                "<td user_attribute='managers'>" + user.managers + "</td></tr>";
    };

});

