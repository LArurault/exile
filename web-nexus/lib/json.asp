<%
Object.prototype.toJSON = function(){
	var json = [];
	for(var i in this){
		if(!this.hasOwnProperty(i)) continue;
		var v = this[i];
		if(typeof v == 'function') continue;

		try {
			json.push( i.toJSON() + ":" + ((v == null)? 'null':v.toJSON()) );
		} catch(e) {
			if(typeof v == 'date')
				json.push( i.toJSON() + ":" + new Date(v).toJSON() );
		}
	}
	return '{\n ' + json.join(',\n ') + '\n}';
}
Array.prototype.toJSON = function(){
	for(var i=0,json=[];i<this.length;i++)
		json[i] = (this[i] != null) ? this[i].toJSON() : 'null';
	return '[' + json.join(', ') + ']'
}

String.prototype.toJSON = function(){
	return '"' +
		this.replace(/(\\|\")/g,'\\$1').replace(/\n|\r|\t/g, function() {
			var a = arguments[0];
			return  (a == '\n')? '\\n':
					(a == '\r')? '\\r':
					(a == '\t')? '\\t': ''
		}) + '"';
}
Boolean.prototype.toJSON = function(){return this}
Date.prototype.toJSON = function(){return 'UTCDate(' + this.getTime() + ')'}
Function.prototype.toJSON = function(){return this}
Number.prototype.toJSON = function(){return this}
RegExp.prototype.toJSON = function(){return this}

// strict but slow
String.prototype.toJSON = function(){
	var tmp = this.split('');
	for(var i=0;i<tmp.length;i++){
		var c = tmp[i];
		(c >= ' ') ?
			(c == '\\') ? (tmp[i] = '\\\\'):
			(c == '"')  ? (tmp[i] = '\\"' ): 0 :
		(tmp[i] = 
			(c == '\n') ? '\\n' :
			(c == '\r') ? '\\r' :
			(c == '\t') ? '\\t' :
			(c == '\b') ? '\\b' :
			(c == '\f') ? '\\f' :
			(c = c.charCodeAt(),('\\u00' + ((c>15)?1:0)+(c%16)))
		)
	}
	return '"' + tmp.join('') + '"';
}
%>