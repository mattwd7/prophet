var dataTable, managers, grid, user_ids = [];
var user_attributes = ['first_name', 'last_name', 'user_tag', 'email', 'title', 'role', 'managers'],
    editable_attributes = ['first_name', 'last_name', 'email', 'title'];

$(document).ready(function(){
    $('.sort div').click(function(){
        var column = $('.column');
        if ($(this).hasClass('admin')){
            column.hide();
            $('#admin').show();
            initAdmin();
            wasAdmin = true;
        } else {
            $('#admin').hide();
            column.show();
            column.removeClass('fade-out-down');
        }
    });

    $('.add-user').click(function(){
        openModal('add-user');
    });

    var users, role;
    grid = $('#admin-grid');
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
        dataTable = grid.DataTable({
            'order': [[ 1, "asc" ], [ 0, "asc" ]],
            'paging': false
        });

        // Use .each() to allow for proper $(this) scope
        $('#admin-grid_wrapper').find('.inline-editable').each(function(){
            makeEditable($(this));
        });

        grid.find("td[user_attribute='managers']").contextmenu({
            menu: createManagersMenu(),
            select: function(event, ui) {
                if (ui.cmd === 'assign_manager'){
                    assignManager(ui.item.data().manager_id);
                } else if (ui.cmd === 'clear_managers') {
                    assignManager(null);
                }
            }
        });

        grid.find("td[user_attribute='role']").contextmenu({
            menu: [
                { title: 'Employee', cmd: '' },
                { title: 'Manager', cmd: 'Manager' },
                { title: 'Admin', cmd: 'Admin' }
            ],
            select: function(event, ui) {
                role = ui.cmd;
                assignRole();
            }
        });

        grid.addClass('initialized');
    }

    function headers(){
        return "<thead><tr><td>First Name</td>" +
            "<td>Last Name</td>" +
            "<td>User Tag</td>" +
            "<td>Email</td>" +
            "<td>Title</td>" +
            "<td>Role</td>" +
            "<td>Managers</td></tr>"
    }

    function userRow(user){
        return  "<tr user_id=" + user.id + "><td user_attribute='first_name' class='inline-editable'>" + user.first_name + "</td>" +
                "<td user_attribute='last_name' class='inline-editable'>" + user.last_name + "</td>" +
                "<td user_attribute='user_tag'>" + user.user_tag + "</td>" +
                "<td user_attribute='email' class='inline-editable'>" + user.email + "</td>" +
                "<td user_attribute='title' class='inline-editable'>" + user.title + "</td>" +
                "<td user_attribute='role'>" + user.role + "</td>" +
                "<td user_attribute='managers'>" + user.managers + "</td></tr>";
    };

    // GRID MANIPULATION

    // selection
    var last_index;
    grid.on('click', 'tbody tr', function(e){
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
        selectedUserIds();
    });

});

////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////

$(document).on('mousedown', '#admin-grid', function(event, ui){
    if (event.which == 3){
        rightClickSelect(event.target);
    }
});

function rightClickSelect(el){
    var row = $(el).closest('tr');
    if(!row.hasClass('selected')){
        row.click();
    }
}

function selectedUserIds(){
    user_ids = [];
    $.each(grid.find('.selected'), function(i, el){
        user_ids.push($(el).attr('user_id'));
    });
    console.log(user_ids);
}

function assignManager(manager_id){
    var data = { user_ids: user_ids };
    if (manager_id != null){
        data['manager_id'] = manager_id;
    }
    $.ajax({
        method: 'put',
        url: '/organizations/update_managers',
        data: data,
        success: function(data){
            for (var i = 0; i < data.updates.length; i++){
                var id = data.updates[i].user_id;
                var managers = data.updates[i].managers;
                $("tr[user_id=" + id + "]").find("td[user_attribute='managers']").text(managers);
            }
        }
    })
}

function assignRole(){
    var data = { user_ids: user_ids, role: role };
    $.ajax({
        method: 'put',
        url: '/organizations/update_user_role',
        data: data,
        success: function(data){
            for (var i = 0; i < data.user_ids.length; i++){
                var id = data.user_ids[i];
                $("tr[user_id=" + id + "]").find("td[user_attribute='role']").text(role)
            }
        }
    })
}

function createManagersMenu(){
    var output = [];
    managers.forEach(function(manager){
        output.push(
            { title: 'Assign to: ' + manager.full_name, cmd: 'assign_manager', data: { manager_id: manager.id } }
        );
    });
    output.push({ title: 'Clear', cmd: 'clear_managers', data: { manager_id: 1} });
    return output;
}

function addRow(row, user_id){
    var grid = $('#admin-grid');
    dataTable.row.add(row).draw(false);
    assignRowAttributes(user_id);

    grid.find("td[user_attribute='managers']").contextmenu({
        menu: createManagersMenu(),
        select: function(event, ui) {
            if (ui.cmd === 'assign_manager'){
                assignManager(ui.item.data().manager_id);
            } else if (ui.cmd === 'clear_managers') {
                assignManager(null);
            }
        }
    });

    grid.find("td[user_attribute='role']").contextmenu({
        menu: [
            { title: 'Employee', cmd: '' },
            { title: 'Manager', cmd: 'Manager' },
            { title: 'Admin', cmd: 'Admin' }
        ],
        select: function(event, ui) {
            role = ui.cmd;
            assignRole();
        }
    });
}

function assignRowAttributes(user_id){
    var row = $('#admin-grid tbody tr').filter(function(i, el){ return $(el).attr('user_id') === undefined });
    row.attr('user_id', user_id);
    for (var i = 0; i < user_attributes.length; i++){
        var attr = user_attributes[i],
            cell = row.find('td').eq(i);
        cell.attr('user_attribute', attr);
        if (editable_attributes.indexOf(attr) >= 0){
            makeEditable(cell);
        }
    }
}

function makeEditable(cell){
    $(cell).addClass('inline-editable');
    $(cell).editable('organizations/update_user', {
        method: 'PUT',
        onblur: 'submit',
        placeholder: '<span class="ph">Click to edit</span>',
        submitdata: { id: $(cell).closest('tr').attr('user_id'), attribute: $(cell).closest('td').attr('user_attribute') },
        data: function(string){ return $.trim(string); }
    });
}