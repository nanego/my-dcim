$(document).ready(function(){
    $(document).on('click', '.frames .couple', function(event){
        window.location.href = $(event.target).closest('.couple').data('url')
    });
});
