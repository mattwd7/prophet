// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var impersonal_feedback_ids;

function closeModal(){
    $('.modal').hide();
    $('body').children().removeClass('blur');
}

function getRecordID(elem){
    return $(elem).attr('id').match(/\d+/)[0];
}

$(document).ready(function(){

    $.ajax({
        url: '/impersonal_feedback_ids',
        method: 'GET',
        success: function(data){
            impersonal_feedback_ids = data;
        }
    });

    $(document).on('keydown', function(e) {
        if (e.which === 13) { // if is enter
            var focus = $(':focus');
            focus.click();
            if(focus.hasClass('submit-tag')){
                focus.blur();
            }
        }
    });

    $(document).on('keydown', 'input', function(e){
        if (e.which == 13){
            $(this).closest('form').submit();
        }
    });

    $(document).on('click', '.submit-tag', function(){
        if ($(this).hasClass('active')){
            $(this).closest('form').submit();
        }
    });

    // MODAL HANDLING

    $(document).on('keydown', function(e) {
        if (e.keyCode == 27) {
            closeModal();
        }
    });

    $(document).on('click', '.modal .close, .modal .cancel', function(){
        closeModal();
    });

});