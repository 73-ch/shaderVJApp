inlets = 2;
outlets = 1;

var s = "";

function anything(r){
	if(this.inlet == 1){
		s = "/" + r + "/";
		post(s);
		return;
	}
	post(r);
	outlet(0, s+r);
}

function msg_int(r) {
	if(this.inlet == 1){
		s = "/" + r + "/";
		post(s);
		return;
	}
}