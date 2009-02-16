var current = 'about'
function show(who) {
	document.getElementById(current).style.display = "none";
	document.getElementById(current + 'focus').className = "unfocus";
	document.getElementById(who).style.display = "block";
	document.getElementById(who + 'focus').className = "focus";
	current = who;
}
