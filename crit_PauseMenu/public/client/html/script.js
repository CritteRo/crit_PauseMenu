let waitingForUiUpdate = false;
let allowExit = false;
let isHydrated = false;

function escapeHtml(html) {
    const text = document.createTextNode(html);
    const p = document.createElement('p');
    p.appendChild(text);
    const retval = p.textContent;
    p.remove();
    return p.innerHTML;
}

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
        if (!isHydrated) {
            setupLabels(
                event.data.labels,
                event.data.overrideTitle,
                event.data.overrideDesc
            );
            setupLanguages(event.data.languages, event.data.currentLanguage);
            setInfoPanelData(event.data.info);
            if (typeof event.data.socialButtons != "undefined") {
                SetupSocialsPanel(event.data.socialButtons);
            }
            isHydrated = true;
        }
		if (typeof event.data.players !== "undefined") {
			SetupOnlinePlayersTable(event.data.players);
		}
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
    const panels = document.querySelectorAll(".panel");
    const headerButtons = document.querySelectorAll(".header-button");
    const leftSideButtons = document.querySelectorAll(".left-container-button");

    panels.forEach( (x) => x.style.display = "none");
    headerButtons.forEach( (x) => toggleHeaderElement(x, false));
    leftSideButtons.forEach( (x) => toggleLeftSideElement(x, false));

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
	const panel = document.querySelector(".info-panel");
	panel.innerHTML = "";
	data.forEach((x) => {
		createInfoPanelSection(x, panel);
	});
}

function createInfoPanelSection(data, panel) {
	if (data[0] === "text") {
		const _header = data[1] || "Missing Header Text";
		const _description = data[2] || "Missing Description Text";
        const _templateHtml = ` <section class="panel-section panel-section-text" style="display: block">
                                    <h3 class="panel-header-text">${_header}</h3>
                                    <p class="panel-text">${_description}</p>
                                    ${data[3] ? `<a href="${data[3]}" target="_blank"><img src="${data[3]}"></a>` : ""}
                                </section>`
		panel.insertAdjacentHTML("beforeend", _templateHtml);

	} else if (data[0] === "title") {
		const _header = data[1] || "Missing Title Header Text";
		const _pill = data[2];
        const _templateHtml = ` <section class="panel-section panel-section-title" style="display: block">
                                    <div class="flexbox">
                                        <h2 class="panel-header-text">${_header}</h2>
                                        ${_pill ? `<span class="panel-header-pill">${_pill}</span>` : ""}
                                    </div>
                                    <div class="line-divider"></div>
                                </section>`
        panel.insertAdjacentHTML("beforeend", _templateHtml);
	}
}

// PLAYER PANEL CONSTRUCTION

function SetupOnlinePlayersTable(data) {
	const panel = document.querySelector(".players-table-body");
	panel.innerHTML = "";
	data.forEach((x) => {
		CreateOnlinePlayerRow(x, panel);
	});
}

function CreateOnlinePlayerRow(data, panel) {
	const _template = `<tr class="players-table-row" style="display: flex">
                            <td>${data.id}</td> 
                            <td>${escapeHtml(data.name)}</td>
                            <td>${data.col1 || ""}</td>
                            <td>${data.col2 || ""}</td>
                            <td>${data.col3 || ""}</td>
                            <td>${data.col4 || ""}</td>
                        </tr>`
    panel.insertAdjacentHTML("beforeend", _template);
}

// SOCIALS CONSTRUCTION

function SetupSocialsPanel(data) {
	const panel = document.querySelector(".socials-grid");
	panel.innerHTML = "";
	data.forEach((x) => {
		CreateSocialButton(x, panel);
	});
}

function CreateSocialButton(data, panel) {
	const _template = ` <button
                            class="noselect socials-button"
                            onclick="toggleButton(this)"
                            optionID="social"
                            url="${data.url}"
                            style='display: inline-block${data.urlImg ? `; background-image: linear-gradient(to top,rgba(0, 0, 0, 0.605),rgba(0, 0, 0, 0.4)),url("${data.urlImg}")` : ""}'
                        >
                            ${data.urlImg ? `<span class="socials-button-flex-end socials-">${data.name}</span>` : `${data.name}`}
                        </button>`
    panel.insertAdjacentHTML("beforeend", _template);
}

// LANGUAGE SELECTOR

function selectSingleOption(el, _value) {
	// helper function to select the existing language
	const _options = el.options;
	if (_options) {
		let i;
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
	const list = document.querySelector(".left-container-language-select");
	list.style.display = "block";
	list.innerHTML = "";
	allLang.forEach((x) => {
		CreateLanguageOption(x, list);
	});
	if (list.length >= 2) {
		selectSingleOption(list, currentLang);
	} else {
		list.style.display = "none";
	}
}

function CreateLanguageOption(data, panel) {
	const _template = ` <option class="language-option-template language-option"
                            value="${data[1]}"
						>${data[0]}</option>`;
	panel.insertAdjacentHTML("beforeend", _template);
}

window.onload = function () {
	const languageSelector = document.querySelector(".left-container-language-select");
    const infoPanelContainer = document.querySelector(".info-panel");
	languageSelector.addEventListener("change", function () {
		// console.log(languageSelector.value);
        isHydrated = false;
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

    infoPanelContainer.addEventListener("click", (e) => {
        let target = e.target.closest("a");
        if (target) {
            e.preventDefault();
            window.invokeNative("openUrl", target.getAttribute("href"));
        }
    });

    window.addEventListener("keydown", (event) => {
        if (event.key == "Escape" || event.key == "p" || event.key == "Backspace") {
            leaveLobby();
        }
    });
};
