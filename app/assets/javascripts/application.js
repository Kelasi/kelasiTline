// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs

$(function() {
	$('.textBox').keypress(function(e){
		var $this = $(this);
		var value = e.charCode;
		var pDetect = 0;
		if ($this.val().length < 1) {
			if (value >= 0x600 && value <= 0x6ff)
				$this.css("direction", "rtl")
			else
				$this.css("direction", "ltr")
		}
	});
});

$(function() {
	$("#submitButton").mouseover(function(e){
		var $this = $(this);
		$this.animate({backgroundColor: "#2e75ce"}, 100 );
		$this.css("color", "#eee");
	})
	$("#submitButton").mouseout(function(e){
		var $this = $(this);
		$this.css("background-color", "#eee");
		$this.css("color", "#2e75ce");
	})
});
