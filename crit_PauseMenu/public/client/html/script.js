var waitingForUiUpdate = false;
var labels = {};

function escapeHtml(str) {
	var div = document.createElement("div");
	div.appendChild(document.createTextNode(str));
	return div.innerHTML;
}

window.addEventListener("message", (event) => {
	if (event.data.type === "NUI_TOGGLE") {
		// var x = document.getElementById("nui-top");
		ToggleNUI(event.data.viz);
		if (event.data.forceInfo) {
			togglePanel(document.querySelector(".infoHeader"));
		}
	}
	if (event.data.type === "UPDATE_UI") {
		waitingForUiUpdate = false;
		if (typeof event.data.isReady !== "undefined") {
			var _iR = document.querySelector(".setReady");
			if (_iR) {
				toggleElement(_iR, event.data.isReady);
			}
		}
		if (typeof event.data.wantsRobber !== "undefined") {
			var _wR = document.querySelector(".setRobber");
			if (_wR) {
				toggleElement(_wR, event.data.wantsRobber);
			}
		} else {
			// console.log("Robber is undefined!");
		}
		if (typeof event.data.wantsHeli !== "undefined") {
			var _wH = document.querySelector(".setHeli");
			if (_wH) {
				toggleElement(_wH, event.data.wantsHeli);
			}
		}

		if (typeof event.data.copModel !== "undefined") {
			var btns = document.querySelectorAll(".cop-vehicle");
			btns.forEach((el) => {
				if (el && el.hasAttribute("model")) {
					if (el.getAttribute("model") === event.data.copModel[0]) {
						toggleElement(el, true);
					} else {
						toggleElement(el, false);
					}
				}
			});
		}
		if (typeof event.data.robModel !== "undefined") {
			var btns = document.querySelectorAll(".rob-vehicle");
			btns.forEach((el) => {
				if (el && el.hasAttribute("model")) {
					if (el.getAttribute("model") === event.data.robModel[0]) {
						toggleElement(el, true);
					} else {
						toggleElement(el, false);
					}
				}
			});
		}
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
		if (typeof event.data.leaderboard !== "undefined") {
			SetupLeaderboardsTable(event.data.leaderboard);
		}
		SetupPlayerVehiclesPanels(
			event.data.robVehicles,
			event.data.copVehicles,
			event.data.useCfxImg
		);
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
			e.preventDefault(); // tell the browser not to respond to the link click
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
	var x = document.body;
	if (viz) {
		x.style.opacity = 1.0;
		x.style.marginTop = "0vh";
	} else {
		x.style.opacity = 0.0;
		x.style.marginTop = "60vh";
	}
}

function toggleButton(el) {
	if (waitingForUiUpdate === false) {
		var option = "NO_OPTION";
		var model = "NO_MODEL";
		var refID = "NO_REF_ID";
		if (el.hasAttribute("optionID")) {
			option = el.getAttribute("optionID");
		} else {
			// console.log("no attri");
		}
		if (el.hasAttribute("model")) {
			model = el.getAttribute("model");
		} else {
			// console.log("no model attri");
		}
		if (el.hasAttribute("refID")) {
			refID = el.getAttribute("refID");
		} else {
			// console.log("no model attri");
		}
		waitingForUiUpdate = true;
	}
}

function toggleElement(el, toggle) {
	var x = el.children[0];
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
	fetch(`https://${GetParentResourceName()}/REQUEST_LEAVE_LOBBY`, {
		method: "POST",
		headers: {
			"Content-Type": "application/json; charset=UTF-8",
		},
		body: JSON.stringify({}),
	});
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
	// Title and Subtitle
	if (overrideTitle && overrideTitle != "") {
		document.querySelector(".main-title").innerHTML =
			escapeHtml(overrideTitle);
	} else {
		document.querySelector(".main-title").innerHTML = escapeHtml(
			data.MAIN_TITLE
		);
	}

	if (overrideDesc && overrideDesc != "") {
		document.querySelector(".main-description").innerHTML =
			escapeHtml(overrideDesc);
	} else {
		document.querySelector(".main-description").innerHTML = escapeHtml(
			data.MAIN_DESCRIPTION
		);
	}

	// Main buttons
	document.querySelector(".setReady").children[0].innerHTML = escapeHtml(
		data.READY_BUTTON
	);
	document.querySelector(".setRobber").children[0].innerHTML = escapeHtml(
		data.SET_ROBBER_BUTTON
	);
	document.querySelector(".setHeli").children[0].innerHTML = escapeHtml(
		data.SET_HELI_BUTTON
	);

	// Header buttons
	document.querySelector(".infoHeader").innerHTML = escapeHtml(
		data.INFO_HEADER_BUTTON
	);
	document.querySelector(".playersHeader").innerHTML = escapeHtml(
		data.PLAYERS_HEADER_BUTTON
	);
	document.querySelector(".leaderboardHeader").innerHTML = escapeHtml(
		data.LEADERBOARD_HEADER_BUTTON
	);
	document.querySelector(".leaveLobby").innerHTML = escapeHtml(
		data.LEAVE_HEADER_BUTTON
	);

	// //Online Players & Leaderboard table headers
	// document.querySelectorAll(".opth-player-name").forEach((x) => {
	// 	x.innerHTML = escapeHtml(data.TBL_PLAYER_NAME);
	// });
	// document.querySelectorAll(".opth-total-points").forEach((x) => {
	// 	x.innerHTML = escapeHtml(data.TBL_TOTAL_POINTS);
	// });
	// document.querySelectorAll(".opth-win-ratio").forEach((x) => {
	// 	x.innerHTML = escapeHtml(data.TBL_WIN_RATIO);
	// });

	// document.querySelector(".opth-is-ready").innerHTML = escapeHtml(
	// 	data.TBL_IS_READY
	// );
	// document.querySelector(".opth-wants-robber").innerHTML = escapeHtml(
	// 	data.TBL_WANTS_ROBBER
	// );
	// document.querySelector(".opth-wants-heli").innerHTML = escapeHtml(
	// 	data.TBL_WANTS_HELI
	// );

	// document.querySelector(".opth-cop-games").innerHTML = escapeHtml(
	// 	data.TBL_COP_GAMES
	// );
	// document.querySelector(".opth-cop-wins").innerHTML = escapeHtml(
	// 	data.TBL_COP_WINS
	// );
	// document.querySelector(".opth-robber-games").innerHTML = escapeHtml(
	// 	data.TBL_ROBBER_GAMES
	// );
	// document.querySelector(".opth-robber-wins").innerHTML = escapeHtml(
	// 	data.TBL_ROBBER_WINS
	// );

	//Vehicle header panels
	document.querySelector(".leave-server-header-label").innerHTML = escapeHtml(
		data.HEADER_SELECT_COP_VEHICLE
	);
}

// INFO PANEL CONSTRUCTION

function setInfoPanelData(data) {
	var sections = document.querySelectorAll(".panel-section-data");
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
	var sections = document.querySelectorAll(".players-table-row");
	sections.forEach((x) => {
		x.remove();
	});
	data.forEach((x) => {
		CreateOnlinePlayerRow(x);
	});
}

function YesNo(bool) {
	if (bool === true) {
		return labels.YES;
	} else {
		return labels.NO;
	}
}

function CreateOnlinePlayerRow(data) {
	var template = document.querySelector(".players-table-row-template");
	var list = template.parentElement;
	var cln = template.cloneNode(true);
	cln.classList.add("players-table-row");
	cln.style.display = "flex";
	cln.children[0].innerHTML = escapeHtml(data.name);
	cln.children[1].innerHTML = YesNo(data.isReady);
	cln.children[2].innerHTML = YesNo(data.wantsRobber);
	cln.children[3].innerHTML = YesNo(data.wantsHeli);
	cln.children[4].innerHTML = escapeHtml(data.totalPoints);
	cln.children[5].innerHTML = escapeHtml(parseFloat(data.wlr).toFixed(2));
	list.appendChild(cln);
}

// LEADERBOARDS PANEL CONSTRUCTION
function SetupLeaderboardsTable(data) {
	var sections = document.querySelectorAll(".leaderboards-table-row");
	var lb = document.querySelector(".leaderboardHeader");
	sections.forEach((x) => {
		x.remove();
	});
	if (data.length > 0) {
		data.forEach((x) => {
			CreateLeaderboardsRow(x);
		});
		if (lb.classList.contains("header-button-disabled")) {
			lb.classList.toggle("header-button-disabled");
			lb.disabled = false;
		}
	} else {
		if (!lb.classList.contains("header-button-disabled")) {
			lb.classList.toggle("header-button-disabled");
			lb.disabled = true;
		}
	}
}

function CreateLeaderboardsRow(data) {
	var template = document.querySelector(".leaderboards-table-row-template");
	var list = template.parentElement;
	var cln = template.cloneNode(true);
	cln.classList.add("leaderboards-table-row");
	cln.style.display = "flex";
	cln.children[0].innerHTML = escapeHtml(data.name);
	cln.children[1].innerHTML = escapeHtml(data.points);
	cln.children[2].innerHTML = escapeHtml(parseFloat(data.wlr).toFixed(2));
	cln.children[3].innerHTML = escapeHtml(data.copGames);
	cln.children[4].innerHTML = escapeHtml(data.copWins);
	cln.children[5].innerHTML = escapeHtml(data.chaseGames);
	cln.children[6].innerHTML = escapeHtml(data.chaseWins);
	list.appendChild(cln);
}

// VEHICLES CONSTRUCTION

function SetupPlayerVehiclesPanels(rob, cop, cfxImg) {}

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
	cln.innerHTML = escapeHtml(data[0]);
	list.appendChild(cln);
}

window.onload = function () {
	var languageSelector = document.querySelector(
		".left-container-language-select"
	);
	languageSelector.addEventListener("change", function () {
		// console.log(languageSelector.value);
		fetch(`https://${GetParentResourceName()}/SEND_TOGGLE_CHANGE`, {
			method: "POST",
			headers: {
				"Content-Type": "application/json; charset=UTF-8",
			},
			body: JSON.stringify({
				type: "changeLang",
				lang: languageSelector.value,
			}),
		});
	});
};
