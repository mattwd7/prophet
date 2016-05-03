$(document).ready(function(){
    var comment_id;

    $(document).on('click', '.comment .actions .edit', function() {
        var path = $(this).attr('href');
        $(".comment .content .text").editable(path, {
            type      : 'textarea',
            event     : 'edit',
            cssclass  : 'edit-comment',
            method    : 'PUT',
            width     : 556,
            height    : 44,
            submit    : 'OK',
            onblur    : 'ignore'
        });

        $(this).closest('.comment').find('.content .text').trigger('edit');
    });

    $(document).on('click', '.comment .actions .delete a', function() {
        openModal('delete-comment');
        comment_id = getRecordID($(this).closest('.comment'));
    });

    $(document).on('click', '#delete-comment .submit-tag', function(){
        $.ajax({
            method: 'DELETE',
            url: '/comments/' + comment_id
            });
        closeModal('delete-comment');
    });

});