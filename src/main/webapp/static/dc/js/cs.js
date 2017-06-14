//检索切换效果
$(function(){
   /* $('.dc_search_ul li:not(.on)').on('click',function(){
        $(this).addClass('on').siblings().removeClass('on');
    });*/
    $(document).on('click','.dc_search_ul li:not(.on)',function(){
        $(this).addClass('on').siblings().removeClass('on');
    });
    $(document).on('click','.jc_hd_menu_list>li',function(){
        $(this).addClass('active').siblings().removeClass('active');;

    });
	/*
    $('.jc_hd_menu_list>li').hover(function () {
        $(this).addClass('active');
    },function () {
        $(this).removeClass('active');
    });
	*/

    /*$('.option_item_con input').iCheck({
        checkboxClass: 'icheckbox_minimal-blue'
    });*/
    //多选按钮点击事件
    $(document).on('click','.more_C',function(){
        $(this).hide().parents('.option_item').find('.submit').show();
        $(this).hide().parents('.option_item').find('input').iCheck({
            checkboxClass: 'icheckbox_minimal-blue'
        });
        //$('.more_dt').click();
        $(this).parents('.option_item').find('.more_dt:not(.active)').click();
    });
    //提交按钮点击事件
    $(document).on('click','.sumbit_btn',function(){
        //待添加
    });
    //取消按钮点击事件
    $(document).on('click','.cancel_btn',function(){
        $(this).parents('.submit').hide();
        $(this).parents('.option_item').find('.more_C').show();
        $(this).parents('.option_item').find('input').iCheck('destroy');
        $(this).parents('.option_item').find('.more_dt.active').click();
    });
//收起过滤条件事件
    $(document).on('click','.filterBtn',function(){
            console.log($(this).find('fa-angle-double-up'));
            if( $(this).find('i').hasClass('fa-angle-double-up')){
                $(this).parents().find('.search_result_option').hide();
                $(this).text('筛选').append('<i class="fa fa-angle-double-down"></i>');
            }else{
                $(this).parents().find('.search_result_option').show();
                $(this).text('收起').append('<i class="fa fa-angle-double-up"></i>');
            }
        }
    );
});
    //icheck后文本点击事件
    $(document).on('click','.option_item_con label',function(){
        $(this).prev().find('input').iCheck('toggle');;
    });
    $(document).on('click','.more_dt',function(){
//console.log(this)
        //收起事件
        if( $(this).parents('.option_item').find('.option_item_con').hasClass('more')){
            $(this).parents('.option_item').find('.option_item_con').removeClass('more');
            $(this).text('更多').append('<span class="down"></span>');
            $(this).removeClass('active');

            $(this).parents('.option_item').find('.submit').hide();
            $(this).parents('.option_item').find('.more_C').show();
            $(this).parents('.option_item').find('input').iCheck('destroy');
        }else{
            $(this).parents('.option_item').find('.option_item_con').addClass('more');
            $(this).text('收起').append('<span class="top"></span>');
            $(this).addClass('active');

        }

		if($(this).parents().find('div').hasClass('hide_data')){
			//console.log(1);
			$('.hide_data').toggle();
		}
    });
    $(document).on('click','.search_tab span:not(.active)',function(){
        var idx=$(this).index();
        $(this).addClass('active').siblings().removeClass('active');
        $('.result_con').hide().removeClass('active');
        $('.result_con:eq('+idx+')').show().addClass('active');

    });

//手风琴效果
$(function(){
    var $caseCol = $('.case_col')
    $caseCol.each(function(){

        var $thisItem = $(this).find('.case_item')

        $thisItem.each(function(){

            var $thisList = $(this),

                $desView = $thisList.find('.case_desc_view'),// 单个卡片总描述

                $decListBox = $thisList.find('.case_desc_list'),

                $decList = $thisList.find('.case_desc_list').find('p'),// 单个卡片 icon 描述列表

                $caseIconBox = $thisList.find('.case_list_box')
            $thisList.on({
                'mouseenter': function(){
                    $thisList.addClass('on').siblings().removeClass('on');
                    return false
                }
            })
            $caseIconBox.on({
                'mouseenter': function(){

                    var thisListIndex = $(this).index()

                    $(this).addClass('case_show_on');

                    $desView.removeClass('on').css('z-index','0').stop().animate({
                        'opacity': '0'
                    });
                    $decListBox.stop().addClass('on').animate({
                        'opacity': '1'
                    });

                    $decList.eq(thisListIndex).addClass('on').stop().animate({
                        'opacity': '1'
                    }).siblings().stop().removeClass('on').animate({
                        'opacity': '0'
                    });
                },
                'focus': function(){
                    $(this).trigger('mouseenter')
                },
                'mouseleave': function(){

                    $(this).removeClass('case_show_on');

                    $desView.addClass('on').stop().animate({
                        'opacity': '1'
                    });
                    $decListBox.stop().removeClass('on').animate({
                        'opacity': '0'
                    },function(){
                        $desView.css('z-index','1');
                    });
                },
                'blur': function(){
                    $(this).trigger('mouseleave')
                }
            },'.case_show')

        })

    })
});