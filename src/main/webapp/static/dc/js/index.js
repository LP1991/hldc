'use strict';
'use strict';




_.Module.define('home/widget/home_mod', function (require, exports, module) {
  
   
  
  var imageInfo = [],// 进行懒加载的图版信息
      
      $lazyImageList = $('img'),// 获取页面所以『img』jq 对象
      
      $lazyBgImageList = $('.JS_bgLazyLoad'), //获取
      
      windowHeight = $(window).height(),//可视区域高度
      
      $window = $(window),//缓存 window jq对象
      
      flag = -2
      
  function getUrl(str){
    return [str.split(',',2)[0].replace(/(^\s*)|(\s*$)/g,'').split(' ',2)[0],str.split(',',2)[1].replace(/(^\s*)|(\s*$)/g,'').split(' ',2)[0]]
  }
  $lazyImageList.each(function(){
    
    var dataSrc = $(this).attr('data-srcset'),
        ifLazy = dataSrc ? true : false,
        $this = $(this)
    if(ifLazy){

      imageInfo.push({
        $lazyImage: $(this),
        lazyImageSrc_1x: getUrl(dataSrc)[0],
        lazyImageSrc_2x: getUrl(dataSrc)[1],
        lazyImageSrcSet: dataSrc,
        lazyImageOffsetTop: $this.parent().offset().top,
        lazyImageHeight: $this.height()
      });
  
    }
     
  })
    // console.log(imageInfo)
  $lazyBgImageList.each(function(){
    
    var bgDataSrc = $(this).attr('data-srcset');
    
    imageInfo.push({
      $lazyImage: $(this),
      lazyImageType: $(this).attr('data-type'),// 图片类型
      lazyImageSrc_1x: getUrl(bgDataSrc)[0],
      lazyImageSrc_2x: getUrl(bgDataSrc)[1],
      lazyImageSrcSet: bgDataSrc,
      lazyImageOffsetTop: $(this).offset().top,
      lazyImageHeight: $(this).height()
    });
    
  })
  function fitImage(scrollY){
    
    var scrollHeight = scrollY
    // if(flag < imageInfo.length){
      
      $(imageInfo).each(function(i){
        
        var imageLoad = null,thisImageInfo = imageInfo[i]

          if( thisImageInfo.lazyImageOffsetTop <= scrollHeight + windowHeight && (thisImageInfo.lazyImageOffsetTop + thisImageInfo.lazyImageHeight) >= scrollHeight){
        	if(thisImageInfo.lazyImageType){
          	thisImageInfo.$lazyImage.css({
            	'background-image': ('-webkit-image-set(url(' + thisImageInfo.lazyImageSrc_1x +') 1x,url('+ thisImageInfo.lazyImageSrc_2x +') 2x)')
          	})
          	if(!thisImageInfo.$lazyImage.attr('style')){
            	thisImageInfo.$lazyImage.css({
              	'background-image': 'url(' + thisImageInfo.lazyImageSrc_2x +')'
            	});
          	}
        	}else{
          	
          	imageLoad = new Image();
                //确认imageLoad.src 有值
                // console.log(flag)
                // console.log("图片路径_1X:"+thisImageInfo.lazyImageSrc_1x)
                if(window.devicePixelRatio){
                 imageLoad.src = window.devicePixelRatio == 2 ? thisImageInfo.lazyImageSrc_2x : thisImageInfo.lazyImageSrc_1x;
                 }else{
                 imageLoad.src = thisImageInfo.lazyImageSrc_1x;
                 }
                 //src定义在前
                imageLoad.onload = function(){
                    thisImageInfo.$lazyImage.attr({
                        'src': imageLoad.src
                    })
                        .siblings('.home_mod_loading').hide(0)
                    // console.log("complete : "+imageLoad.complete )
                }

          	imageLoad.onerror = function(){
                console.error("loadImgErr_index.js_106")
                imageLoad = null;
          	}
          	

        	}
        	
          flag ++
          imageInfo[i].lazyImageOffsetTop = 0;
      
        }
      })   
    /*}else{
      $window.off('scroll');
      flag = null;
      imageInfo = null;
      getUrl = null;
      $lazyImageList = null;
      $lazyBgImageList = null;
    }*/
  }
  
  fitImage($window.scrollTop());
  
	$window.on('scroll',function(){
  	
  	var scrollHeight = $window.scrollTop();
  	
  	fitImage(scrollHeight);
  	
	})
	var supports = (function() {
    var div = document.createElement('div'),
        vendors = 'Khtml Ms O Moz Webkit'.split(' '),
        len = vendors.length;
  
     return function(prop) {
        if ( prop in div.style ) return true;
  
        prop = prop.replace(/^[a-z]/, function(val) {
           return val.toUpperCase();
        });
  
        while(len--) {
           if ( vendors[len] + prop in div.style ) {
              return true;
           }
        }
        return false;
     };
  })()
	function ie8Midia(){
    if($window.width()<=1004){
      $('body').addClass('w_1024');	
  	}else{
    	$('body').removeClass('w_1024');
  	}	
	}
	
	function ifIE8(){
  	if(!supports('border-radius')){
    	ie8Midia();
    	$window.resize(function(){
      	ie8Midia();
    	}); 
    	supports = null;  	
  	}else{
    	ie8Midia = null;
  	}
	}

  ifIE8();

});
'use strict';




_.Module.define('home/widget/banner', function (require, exports, module) {

  var srcInfo = [],
      $imgList = $('#fcSliderWp').find('.fc_item'),
      $switchList = $('#fcSliderNav').find('span'),
      imgListLength = $imgList.length,
      loadNum = 0,
      timer = null,
      COUNT = 0;  
      
  function getUrl(str){
    return [str.split(',',2)[0].replace(/(^\s*)|(\s*$)/g,'').split(' ',2)[0],str.split(',',2)[1].replace(/(^\s*)|(\s*$)/g,'').split(' ',2)[0]]
  }
      
  $imgList.each(function(){
    var $thisImgBg = $(this).find('.fc_item_bg'),
        src = $thisImgBg.attr('data-srcset');
    srcInfo.push({
      $thisBg: $thisImgBg,
      imgSrc_1x: getUrl(src)[0],
      imgSrc_2x: getUrl(src)[1]
    })
  })
  function loadImageFn(opt){
    
    var thisSrcInfo = srcInfo[opt],
        loadImg = null,
        thisFn = loadImageFn;
      
    loadImg = new Image();
    
    loadImg.onload = function(){    
      thisSrcInfo.$thisBg.css({
        'background-image': 'url('+ loadImg.src + ')'
      }).siblings('.fc_item_loading').hide();        
      loadImg = null;
      loadNum ++;
      if(loadNum < imgListLength){
        thisFn(loadNum);
        thisFn = null; 
      }else{
        srcInfo = null;
        getUrl = null;
        loadImageFn = null;
        loadNum = null; 
      }
    }
    
    loadImg.onerror = function(){
      thisSrcInfo.$thisBg.siblings('.fc_item_loading').show();
      loadImg = null;
      loadNum ++;	
      if(loadNum < imgListLength){
        thisFn(loadNum);
        thisFn = null; 
      }else{
        srcInfo = null;
        getUrl = null;
        loadImageFn = null; 
        loadNum = null;
      }
    }
    
    if(window.devicePixelRatio){
    	loadImg.src = window.devicePixelRatio == 2 ? thisSrcInfo.imgSrc_2x : thisSrcInfo.imgSrc_1x;
  	}else{
    	loadImg.src = thisSrcInfo.imgSrc_1x;
  	} 	
  	
  }
  function imgChange(opt){   
    $switchList.eq(opt).addClass('on').siblings().removeClass('on');
    $imgList.eq(opt).stop().animate({
      'opacity': '1'
    },300).addClass('active').siblings().stop().animate({
      'opacity': '0'
    },300).removeClass('active');
    
    COUNT = opt;
    
    if(COUNT < imgListLength - 1){
      COUNT ++;
    }else{
      COUNT = 0;
    }
  }
  $('#fcSliderNav').on({
    'mouseenter': function(){
      var thisIndex = $(this).index();
      clearInterval(timer);
      imgChange(thisIndex);    
    },
    'mouseleave': function(){
      timer = setInterval(function(){
        imgChange(COUNT);  
      },10000);
    }
  },'span');
  
  timer = setInterval(function(){
    imgChange(COUNT);  
  },10000)
  loadImageFn(0);

});
'use strict';



_.Module.define('home/widget/bservice_v2', function (require, exports, module) {
	$('#bsListBox').on({
		'mouseenter': function(){
			$(this).addClass('on').siblings().removeClass('on');	
		},
		'focus': function(){
  		$(this).trigger('mouseenter')
		}
	},'.bs_item');


});
'use strict';
'use strict';



_.Module.define('home/widget/case_v2', function (require, exports, module) {
	
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
'use strict';
'use strict';
'use strict';
'use strict';

_.Module.define('home/widget/ads', function (require, exports, module) {
    // return $(this).attr("data-href")!=""?true:false;
    $(".ads").on("click",":data-ref",function () {
        window.open($(this).attr("data-href")+".html")
    })

});
'use strict';

