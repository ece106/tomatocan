document.querySelector("div#location").style.display = "none";

function borderSelectChange(value) {
	let colorSelect = document.querySelector("div#color");
	let widthSelect = document.querySelector("div#width");
	if (value.toLowerCase() === "yes") {
		colorSelect.style.display = "block";
		widthSelect.style.display = "block";
	} else {
		colorSelect.style.display = "none";
		widthSelect.style.display = "none";
	}
}

function positionSelectChange(value) {
	let locationSelect = document.querySelector("div#location");
	if (value.substring(0,18).toLowerCase() === "according to where") {
		locationSelect.style.display = "none";
	} else {
		locationSelect.style.display = "block";
	}
}

$(document).on('change', '#embed_code_border', function() {
	borderSelectChange(this.value);
});
$(document).on('change', '#embed_code_position', function() {
	positionSelectChange(this.value);
});

// Neither of the following pairs of lines were able to get the code to run. Adding listener to element rather than document is ideal.
// document.querySelector("#embed_code_border").onchange = borderSelectChange();
// document.querySelector("#embed_code_position").onchange = positionSelectChange();

// document.querySelector("#embed_code_border").addEventListener("change", borderSelectChange());
// document.querySelector("#embed_code_position").addEventListener("change", positionSelectChange());
