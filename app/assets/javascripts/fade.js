var colorFade = function(elmOrElmId, duration, state, iColor, fColor) {
	this.set(elmOrElmId, duration, state);
};

colorFade.prototype = {
	set: function(elmOrElmId, duration, state, iColor, fColor) {

		this.fadeDuration = duration;
		this.element = (typeof elmOrElmId == 'string') ? $(elmOrElmId) : elmOrElmId;
		this.fadeState = (state && state == 1) ? 1 : -1;
		this.fadeTimeLeft = duration;
		this.lastTick = this.newTick();

		this.iRed = this.hexToR("eeeeee");
		this.iGreen = this.hexToG("eeeeee");
		this.iBlue = this.hexToB("eeeeee");

		this.fRed = this.hexToR("2e75ce");
		this.fGreen = this.hexToG("2e75ce");
		this.fBlue = this.hexToB("2e75ce");

		this.animate();
	},

	hexToR: function(h) {
		return parseInt((this.cutHex(h)).substring(0,2),16)
	},

	hexToG: function(h) {
		return parseInt((this.cutHex(h)).substring(2,4),16)
	},

	hexToB: function(h) {
		return parseInt((this.cutHex(h)).substring(4,6),16)
	},

	cutHex: function(h) {
		var c = h.charAt(0);
		return (c=="#") ? h.substring(1,7):h
		// return h.substring(1,7);
	},
       
	newTick: function() {
		return new Date().getTime();
	},
       
	returnElapsedTicks: function() {
		return this.currentTick - this.lastTick;
	},
       
    animate: function() {
       
		this.currentTick = this.newTick();

		var self = this;
		var elapsedTicks = this.returnElapsedTicks();

		var helper = function() {
			self.animate();
		};
		       
		if (this.fadeTimeLeft <= elapsedTicks) {
			this.element.style.backgroundColor = ((this.fadeState == -1) ? "#2e75ce" : "#eeeeee");
			return;
		}
		       
		this.fadeTimeLeft -= elapsedTicks;

		var newOptVal = this.fadeTimeLeft / this.fadeDuration;

		var newRval = ((this.fadeState == -1) ? this.fRed - newOptVal*(this.fRed - this.iRed) : this.iRed + newOptVal*(this.fRed - this.iRed));
		var newGval = ((this.fadeState == -1) ? this.fGreen - newOptVal*(this.fGreen - this.iGreen) : this.iGreen + newOptVal*(this.fGreen - this.iGreen));
		var newBval = ((this.fadeState == -1) ? this.fBlue - newOptVal*(this.fBlue - this.iBlue) : this.iBlue + newOptVal*(this.fBlue - this.iBlue));

		newRval = (newRval > 254) ? 255 : parseInt(newRval);
		newGval = (newGval > 254) ? 255 : parseInt(newGval);
		newBval = (newBval > 254) ? 255 : parseInt(newBval);

		this.element.style.backgroundColor = "rgb(" + newRval + "," + newGval + "," + newBval + ")";

		this.lastTick = this.currentTick;
		this.currentTick = this.newTick();
		       
		setTimeout(helper, 33);
    }
};

var init = function(elmsOrElmIdArr, duration, state, iColor, fColor) {
	for (var i = 0, l = elmsOrElmIdArr.length; i < l; i++) {
		new colorFade(elmsOrElmIdArr[i], duration, state);
	}
};
