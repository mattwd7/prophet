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

    var users, managers;
    var grid = $('#admin-grid');

    function initAdmin(){
        if (!grid.hasClass('initialized')) {
            $.ajax({
                method: 'get',
                url: '/organizations/get_users',
                success: function (data) {
                    users = data.users;
                    managers = data.managers;
                    initGrid(users);
                }
            })
        }
    }

    function initGrid(users){
        grid.append(headers());
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
        grid.contextmenu({
            delegate: "td[user_attribute='managers']",
            menu: createManagersMenu(),
            select: function(event, ui) {
                alert("Manager id = " + ui.cmd);
                var selected_rows = grid.find('.selected');
                var user_ids = selected_rows.map(function(i, el){ return $(el).attr('user_id') });
                console.log(user_ids);
                $.ajax({
                    method: 'POST',
                    url: '/organizations/bulk_update',
                    data: { user_ids: user_ids, manager_id: ui.cmd },
                    success: function(data){
                        console.log(data);
//                        selected_rows.find("td[user_attribute='managers']").each(function(i, el){
//                            $(el).text(data);
//                        })
                    }
                })
            }
        });
//        $("td[user_attribute='managers']").contextmenu(menu, {mouseClick: 'right'});
    }

    function headers(){
        return "<thead><tr><td>First Name</td>" +
            "<td>Last Name</td>" +
            "<td>User Tag</td>" +
            "<td>Email</td>" +
            "<td>Manager</td></tr>"
    }

    function userRow(user){
        return  "<tr user_id=" + user.id + "><td user_attribute='first_name' class='inline-editable'>" + user.first_name + "</td>" +
                "<td user_attribute='last_name' class='inline-editable'>" + user.last_name + "</td>" +
                "<td user_attribute='user_tag'>" + user.user_tag + "</td>" +
                "<td user_attribute='email' class='inline-editable'>" + user.email + "</td>" +
                "<td user_attribute='managers'>" + user.managers + "</td></tr>";
    };

    // GRID MANIPULATION

    // selection
    var last_index;
    grid.on('click', 'tr', function(e){
        var index = grid.find('tr').index(this);
        if (e.shiftKey){
            if (index > last_index) {
                for (var i = last_index; i <= index; i++) {
                    grid.find('tr').eq(i).addClass('selected');
                }
            } else {
                for (var i = last_index; i >= index; i--) {
                    grid.find('tr').eq(i).addClass('selected');
                }
            }
        } else {
            grid.find('tr').removeClass('selected');
            $(this).addClass('selected');
        }
        last_index = index;
    });

    // context menu
    function createManagersMenu(){
        var output = [];
        managers.forEach(function(manager){
            output.push(
                { title: 'Assign to: ' + manager.user_tag, cmd: manager.id }
            );
        });
        return output;
    }


//    $("td[user_attribute='managers']").contextmenu(menu);

});

