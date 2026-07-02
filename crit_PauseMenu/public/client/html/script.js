let waitingForUiUpdate = false;
let allowExit = false;
let labels = {};

window.addEventListener("message", (event) => {
	if (event.data.type === "NUI_TOGGLE") {
		// var x = document.getElementById("nui-top");
		ToggleNUI(event.data.viz);
		if (event.data.forcePanel) {
			togglePanel(
				document.querySelector(event.data.forcePanel) ||
					document.querySelector(".infoHeader")
			);
		}
	}
	if (event.data.type === "UPDATE_PLAYER_LIST") {
		waitingForUiUpdate = false;
		if (typeof event.data.players !== "undefined") {
			SetupOnlinePlayersTable(event.data.players);
		}
	}
	if (event.data.type === "SETUP_DATA") {
		setupLabels(
			event.data.labels,
			event.data.overrideTitle,
			event.data.overrideDesc
		);
		labels = event.data.labels;
		setupLanguages(event.data.languages, event.data.currentLanguage);
		setInfoPanelData(event.data.info);
		if (typeof event.data.players !== "undefined") {
			SetupOnlinePlayersTable(event.data.players);
		}
		if (typeof event.data.socialButtons != "undefined") {
			SetupSocialsPanel(event.data.socialButtons);
		}
	}
});

// Catch <a> links to open the browser automagically.
// Thanks StackOverflow
document.addEventListener("click", (e) => {
	let target = e.target.closest("a");
	if (target) {
		// if the click was on or within an <a>
		// Check if the <a> tag is part of the Info Panel.
		var parent = target.closest(".info-panel");
		if (parent) {
			e.preventDefault();
			window.invokeNative("openUrl", target.getAttribute("href"));
		}
	}
});

window.addEventListener("keydown", (event) => {
	if (event.key == "Escape" || event.key == "p" || event.key == "Backspace") {
		leaveLobby();
	}
});

function ToggleNUI(viz) {
	const x = document.body;
	if (viz) {
		x.style.opacity = 1.0;
		x.style.marginTop = "0vh";
		allowExit = false;
		setTimeout(function () {
			allowExit = true;
		}, 200);
	} else {
		x.style.opacity = 0.0;
		x.style.marginTop = "60vh";
		allowExit = false;
	}
}

function toggleButton(el) {
	if (waitingForUiUpdate === false) {
		let option = "NO_OPTION";
		if (el.hasAttribute("optionID")) {
			option = el.getAttribute("optionID");
			if (option === "social") {
				window.invokeNative("openUrl", el.getAttribute("url"));
			} else {
				fetch(`https://${GetParentResourceName()}/TOGGLE_BUTTON`, {
					method: "POST",
					headers: {
						"Content-Type": "application/json; charset=UTF-8",
					},
					body: JSON.stringify({
						option: option,
					}),
				});
			}
		} else {
			console.log(
				"toggleButton :: missing optionID attribute for: " +
					el.innerHTML
			);
		}
	}
}

function toggleElement(el, toggle) {
	const x = el.children[0];
	if (x) {
		if (x.classList.contains("activeBtn") && !toggle) {
			x.classList.toggle("activeBtn");
			// console.log("I'm here!");
		} else if (!x.classList.contains("activeBtn") && toggle) {
			x.classList.toggle("activeBtn");
		}
	}
}

function toggleHeaderElement(el, toggle) {
	if (el) {
		if (el.classList.contains("header-button-active") && !toggle) {
			el.classList.toggle("header-button-active");
		} else if (!el.classList.contains("header-button-active") && toggle) {
			el.classList.toggle("header-button-active");
		}
	}
}

function toggleLeftSideElement(el, toggle) {
	if (el) {
		if (el.classList.contains("activeBtn2") && !toggle) {
			el.classList.toggle("activeBtn2");
		} else if (!el.classList.contains("activeBtn2") && toggle) {
			el.classList.toggle("activeBtn2");
		}
	}
}

function togglePanel(el) {
	// Clear all first

	document.querySelector(".info-panel").style.display = "none";
	toggleHeaderElement(document.querySelector(".infoHeader"), false);
	document.querySelector(".socials-panel").style.display = "none";
	toggleLeftSideElement(document.querySelector(".socialsHeader"), false);
	document.querySelector(".players-panel").style.display = "none";
	toggleHeaderElement(document.querySelector(".playersHeader"), false);
	document.querySelector(".leave-server-panel").style.display = "none";
	toggleHeaderElement(document.querySelector(".closeMenu"), false);
	document.querySelector(".empty-panel").style.display = "none";
	toggleLeftSideElement(document.querySelector(".socialsHeader"), false);
	toggleLeftSideElement(document.querySelector(".mapHeader"), false);
	document.querySelector(".map-panel").style.display = "none";
	toggleLeftSideElement(document.querySelector(".settingsHeader"), false);
	toggleLeftSideElement(document.querySelector(".galleryHeader"), false);

	// Activate Correct panel
	if (el && el.hasAttribute("panel")) {
		if (el.hasAttribute("leftSide")) {
			el.classList.toggle("activeBtn2");
		} else {
			el.classList.toggle("header-button-active");
		}
		if (el.getAttribute("panel") === ".map-panel") {
			document.querySelector(el.getAttribute("panel")).style.display =
				"grid";
		} else if (el.getAttribute("panel") === ".leave-server-panel") {
			document.querySelector(el.getAttribute("panel")).style.display =
				"flex";
		} else {
			document.querySelector(el.getAttribute("panel")).style.display =
				"block";
		}

		fetch(`https://${GetParentResourceName()}/TOGGLE_PANEL`, {
			method: "POST",
			headers: {
				"Content-Type": "application/json; charset=UTF-8",
			},
			body: JSON.stringify({
				panel: el.getAttribute("panel"),
				option: el.getAttribute("optionID"),
			}),
		});
	}
}

function leaveLobby() {
	if (allowExit === true) {
		fetch(`https://${GetParentResourceName()}/REQUEST_LEAVE_LOBBY`, {
			method: "POST",
			headers: {
				"Content-Type": "application/json; charset=UTF-8",
			},
			body: JSON.stringify({}),
		});
	}
}

function openMap() {
	fetch(`https://${GetParentResourceName()}/TOGGLE_PANEL_MAP`, {
		method: "POST",
		headers: {
			"Content-Type": "application/json; charset=UTF-8",
		},
		body: JSON.stringify({
			option: "map",
		}),
	});
}

function setupLabels(data, overrideTitle, overrideDesc) {
    const ELEMENTS = document.querySelectorAll("[data-label]");
    ELEMENTS.forEach( (el) => {
        const LABEL = el.dataset.label;
        if (data[LABEL]) el.textContent = data[LABEL];
        if (LABEL === "MAIN_TITLE" && overrideTitle) el.textContent = overrideTitle;
        if (LABEL === "MAIN_DESCRIPTION" && overrideDesc) el.textContent = overrideDesc;
    })
}

// INFO PANEL CONSTRUCTION

function setInfoPanelData(data) {
	const sections = document.querySelectorAll(".panel-section-data");
	sections.forEach((x) => {
		x.remove();
	});
	data.forEach((x) => {
		createInfoPanelSection(x);
	});
}

function createInfoPanelSection(data) {
	if (data[0] === "text") {
		var _header = data[1] || "Missing Header Text";
		var _description = data[2] || "Missing Description Text";

		var template = document.querySelector(".panel-section-text-template");
		var list = template.parentElement;
		var cln = template.cloneNode(true);
		cln.classList.add("panel-section-data");
		cln.style.display = "block";
		if (_header != "") {
			cln.children[0].innerHTML = _header;
		} else {
			cln.children[0].remove();
		}
		if (_description != "") {
			cln.children[1].innerHTML = _description;
		} else {
			cln.children[1].remove();
		}
		if (data[3]) {
			var imgLink = document.createElement("a");
			if (data[4]) {
				imgLink.setAttribute("href", data[4]);
			} else {
				imgLink.setAttribute("href", data[3]);
			}
			imgLink.setAttribute("target", "_blank");
			var oImg = document.createElement("img");
			oImg.setAttribute("src", data[3]);
			imgLink.appendChild(oImg);
			cln.appendChild(imgLink);
		}
		list.appendChild(cln);
	} else if (data[0] === "title") {
		var _header = data[1] || "Missing Title Header Text";
		var _pill = data[2];

		var template = document.querySelector(".panel-section-title-template");
		var list = template.parentElement;
		var cln = template.cloneNode(true);
		cln.classList.add("panel-section-data");
		cln.style.display = "block";
		cln.children[0].children[0].innerHTML = _header;
		if (_pill) {
			cln.children[0].children[1].innerHTML = _pill;
		} else {
			cln.children[0].children[1].innerHTML = "";
			cln.children[0].children[1].style.display = "none";
		}
		list.appendChild(cln);
	}
}

// PLAYER PANEL CONSTRUCTION

function SetupOnlinePlayersTable(data) {
	const sections = document.querySelectorAll(".players-table-row");
	sections.forEach((x) => {
		x.remove();
	});
	data.forEach((x) => {
		CreateOnlinePlayerRow(x);
	});
}

function CreateOnlinePlayerRow(data) {
	var template = document.querySelector(".players-table-row-template");
	var list = template.parentElement;
	var cln = template.cloneNode(true);
	cln.classList.add("players-table-row");
	cln.style.display = "flex";
	cln.children[0].textContent = data.id;
	cln.children[1].textContent = data.name;
	cln.children[2].textContent = (data.col1 || "");
	cln.children[3].textContent = (data.col2 || "");
	cln.children[4].textContent = (data.col3 || "");
	cln.children[5].textContent = (data.col4 || "");
	list.appendChild(cln);
}

// SOCIALS CONSTRUCTION

function SetupSocialsPanel(data) {
	var sections = document.querySelectorAll(".socials-button");
	sections.forEach((x) => {
		x.remove();
	});
	data.forEach((x) => {
		CreateSocialButton(x);
	});
}

function CreateSocialButton(data) {
	var template = document.querySelector(".socials-button-template");
	var list = template.parentElement;
	var cln = template.cloneNode(true);
	cln.classList.add("socials-button");
	cln.style.display = "inline-block";
	cln.style.backgroundImage = `linear-gradient(to top,rgba(0, 0, 0, 0.605),rgba(0, 0, 0, 0.4)),url("${data.urlImg || ""}")`;
	cln.setAttribute("optionID", "social");
	cln.setAttribute("url", data.url);
	cln.children[0].textContent = data.name;
	list.appendChild(cln);
}

// LANGUAGE SELECTOR

function selectSingleOption(el, _value) {
	// helper function to select the existing language
	var _options = el.options;
	if (_options) {
		var i;
		el.value = "";
		for (i = 0; i < _options.length; i++) {
			if (_options[i].value === String(_value)) {
				el.value = String(_value);
			}
		}
		el.dispatchEvent(new Event("change"));
	}
}

function setupLanguages(allLang, currentLang) {
	var list = document.querySelector(".left-container-language-select");
	list.style.display = "block";
	var sections = document.querySelectorAll(".language-option");
	sections.forEach((x) => {
		x.remove();
	});
	allLang.forEach((x) => {
		CreateLanguageOption(x);
	});
	if (list.length > 2) {
		selectSingleOption(list, currentLang);
	} else {
		list.style.display = "none";
	}
}

function CreateLanguageOption(data) {
	var template = document.querySelector(".language-option-template");
	var list = template.parentElement;
	var cln = template.cloneNode(true);
	cln.classList.add("language-option");
	cln.setAttribute("value", data[1]);
	cln.textContent = data[0];
	list.appendChild(cln);
}

window.onload = function () {
	const languageSelector = document.querySelector(".left-container-language-select");
	languageSelector.addEventListener("change", function () {
		// console.log(languageSelector.value);
		fetch(`https://${GetParentResourceName()}/TOGGLE_BUTTON`, {
			method: "POST",
			headers: {
				"Content-Type": "application/json; charset=UTF-8",
			},
			body: JSON.stringify({
				option: "changeLang",
				lang: languageSelector.value,
			}),
		});
	});
};
