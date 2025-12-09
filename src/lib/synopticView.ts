import { request } from "@acdh-oeaw/lib";

export function loadContent(
	documentId: string,
	synopticViewId: string,
	hash: string,
	pdN: string,
): Promise<void> {
	// choose html class for node to be removed
	removeColumnContent(synopticViewId);

	// options for saxonTransform
	const dir = "../edition-raw/";

	// column one result
	return transform({
		fileDir: dir,
		fileName: documentId,
		htmlID: synopticViewId,
		hash: hash,
		page: pdN,
	});
}

async function transform(options: {
	fileDir: string;
	fileName: string;
	htmlID: string;
	hash: string;
	page: string;
}): Promise<void> {
	try {
		const url = options.fileDir + options.fileName + ".html";
		console.log("Loading synoptic view from: " + options.fileName);
		const html = (await request(url, { responseType: "text" })) as string;

		const container = document.getElementById(options.htmlID);
		const parent = container?.parentElement;

		if (container && parent) {
			if (parent.classList.contains("hidden")) {
				parent.classList.toggle("hidden");
				parent.classList.toggle("active");
			}

			container.innerHTML = html;
			// complete citation after HTML is inserted into DOM
			completeCitation(options.fileName);
			container.classList.add("h-auto");
			scroll_synoptic();
		}

		if (!options.hash || options.hash === "") return;

		// Add a small delay to ensure DOM is fully rendered
		setTimeout(() => {
			const word = document.getElementById(options.hash);

			if (word) {
				//word.scrollIntoView({ behavior: "smooth", block: "center", inline: "center" });
				//word.style.backgroundColor = "red"; // ← THIS LINE sets the yellow background
				word.style.color = "red";
				word.style.fontWeight = "bold";
				word.style.padding = "2px 4px";
				word.style.borderRadius = "3px";
			}
		}, 100);
	} catch (error) {
		console.error(error);
	}
}

function removeColumnContent(id: string) {
	const result = document.getElementById(id);
	if (result) {
		result.innerHTML = "";
	}
}

//	complete citation for current document and page
function completeCitation(id: string) {
	const cittoday = document.getElementById("cittoday");
	const citurl = document.getElementById("citurl");
	if (citurl) {
		const currentsrv = window.location.origin;
		//const currentsrv = "https://abacus.acdh.oeaw.ac.at";
		citurl.innerText = currentsrv + "/suche?seite=" + id;
	}
	if (cittoday) {
		const now = new Date();
		const day = String(now.getDate()).padStart(2, "0");
		const month = String(now.getMonth() + 1).padStart(2, "0");
		const year = now.getFullYear();
		const formattedDate = `${day}.${month}.${year}`;
		cittoday.textContent = formattedDate;
	}
}

function scroll_synoptic() {
	/*
##################################################################
get container holding images urls as child elements
get container for osd viewer
get container wrapper of osd viewer
##################################################################
*/
	// var container = document.getElementById("container_facs_2");
	// container.style.display = "none";
	const text = document.querySelector(".text");
	let width = text ? text.clientWidth : screen.width;
	const facs = document.getElementById("container_facs_1");
	let container = facs ? facs : document.createElement("div");
	// const wrapper = document.getElementsByClassName("facsimiles")[0];
	const url = "http://clarin.oeaw.ac.at/cr-images";

	/*
##################################################################
check if osd viewer is visible or not
if true get width from sibling container
if false get with from sibling container divided by half
height is always the screen height minus some offset
##################################################################
*/

	// set osd wrapper container width
	container = document.querySelector(".section") ?? document.createElement("div");
	width = container.clientWidth;
	container = document.getElementById("viewer-1") ?? document.createElement("div");
	container.style.width = `${String(width / 1.16)}px`;
	container.style.height = `${String(width / 1.16)}px`;

	// set container_facs_1 height to match its parent viewer-1
	if (facs) {
		facs.style.height = container.style.height;
	}

	/*
##################################################################
get all image urls stored in span el class tei-xml-images
creates an array for osd viewer with static images
##################################################################
*/
	const element = document.getElementsByClassName("pb");
	const img1 = element[0].getAttribute("id");
	const img = url + img1;
	const tileSources = [
		{
			type: "image",
			url: img,
		},
	];

	/*
##################################################################
initialize osd
##################################################################
*/
	// @ts-expect-error in development
	const viewer = OpenSeadragon({
		id: "container_facs_1",
		prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/",
		// @ts-expect-error in development
		tileSources: tileSources,
		visibilityRatio: 1,
		sequenceMode: false,
		showNavigationControl: false,
		showNavigator: false,
		showSequenceControl: false,
		showZoomControl: false,
		zoomInButton: "osd_zoom_in_button",
		zoomOutButton: "osd_zoom_out_button",
		homeButton: "osd_zoom_reset_button",
		constrainDuringPan: true,
	});

	viewer.viewport.goHome = function () {
		fitVertically_align_left_bottom();
	};

	function fitVertically_align_left_bottom() {
		const initial_bounds = viewer.viewport.getBounds();
		const ratio = initial_bounds.width / initial_bounds.height;
		const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
		const new_height: number =
			// @ts-expect-error in development
			ratio > tiledImage.contentAspectX ? tiledImage.normHeight : 1 / ratio;
		// @ts-expect-error in development
		const normed_height: number = tiledImage.normHeight;
		// const bounds_y: number = -(new_height - tiledImage.normHeight);
		const new_bounds =
			// @ts-expect-error in development
			ratio > tiledImage.contentAspectX
				? // @ts-expect-error in development
					new OpenSeadragon.Rect(0, 0, new_height, normed_height)
				: // @ts-expect-error in development
					new OpenSeadragon.Rect(0, 0, 1, new_height);
		viewer.viewport.fitBounds(new_bounds, true);
	}
}
