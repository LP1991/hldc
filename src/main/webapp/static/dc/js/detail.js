/**
 * Created by Administrator on 2016/11/8.
 */

$(function(){
    $(document).on('click','.tab span:not(.active)',function(){
        var idx=$(this).index();
        $(this).addClass('active').siblings().removeClass('active');
        $(this).parents('.tab').siblings('.tab_content').children(':eq('+idx+')').addClass('active').siblings().removeClass('active');;

       /* $('.tab_content').hide().removeClass('active');
        $('.result_con:eq('+idx+')').show().addClass('active');*/
    });

    $(document).on('click','.down_tab li:not(.on)',function(){

        var idx=$(this).index();
        $(this).addClass('on').siblings().removeClass('on');
        $(this).parents('.down_tab').siblings('.down_tab_content').children(':eq('+idx+')').addClass('active').siblings().removeClass('active');;
    });
        $('#example').dataTable( {
            "paging":   false,
            "ordering": false,
            "info":     false,
            "searching": false,
        } );
})