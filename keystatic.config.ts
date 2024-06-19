import {
	collection,
	config,
	fields,
	// type GitHubConfig,
	type LocalConfig,
	singleton,
} from "@keystatic/core";
import { wrapper } from "@keystatic/core/content-components";

// const isProd = process.env.NODE_ENV === "production";
const localMode: LocalConfig["storage"] = {
	kind: "local",
};
// const remoteMode: GitHubConfig["storage"] = {
// 	kind: "github",
// 	repo: "wiener-diarium/curved-conjunction",
// };

export default config({
	storage: localMode,
	singletons: {
		about: singleton({
			label: "Über uns",
			path: "src/content/about",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/about",
							publicPath: "/images/about",
						},
					},
					components: {
						TextImage: wrapper({
							label: "Text und Bild",
							description: "Ein Container mit Text und einem Bild",
							schema: {
								text: fields.text({
									label: "Text",
									description: "Der Text, der neben dem Bild angezeigt wird.",
									validation: {
										length: {
											min: 20,
										},
									},
								}),
								image: fields.image({
									label: "Bild",
									directory: "public/images/about",
									publicPath: "/images/about",
								}),
								image_alt: fields.text({
									label: "Bild Alt",
									description: "Der Alt-Text für das Bild",
								}),
							},
						}),
						ImageGallery: wrapper({
							label: "Gallerie",
							description: "Eine Gallerie mit Bildern",
							schema: {
								images: fields.array(
									fields.object(
										{
											image: fields.image({
												label: "Bild",
												directory: "public/images/about",
												publicPath: "/images/about",
											}),
											alt: fields.text({
												label: "Alt",
											}),
											caption: fields.text({
												label: "Caption",
											}),
										},
										{
											label: "Bilder",
										},
									),
								),
							},
						}),
						SingleImage: wrapper({
							label: "Einzelbild",
							description: "Ein einzelnes Bild",
							schema: {
								image: fields.object(
									{
										image: fields.image({
											label: "Bild",
											directory: "public/images/about",
											publicPath: "/images/about",
										}),
										alt: fields.text({
											label: "Alt",
										}),
										caption: fields.text({
											label: "Caption",
										}),
									},
									{
										label: "Einzelbild",
									},
								),
							},
						}),
					},
				}),
			},
		}),
		help: singleton({
			label: "Hilfe",
			path: "src/content/help",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/help",
							publicPath: "/images/help",
						},
					},
					components: {
						TextImage: wrapper({
							label: "Text und Bild",
							description: "Ein Container mit Text und einem Bild",
							schema: {
								text: fields.text({
									label: "Text",
									description: "Der Text, der neben dem Bild angezeigt wird.",
									validation: {
										length: {
											min: 20,
										},
									},
								}),
								image: fields.image({
									label: "Bild",
									directory: "public/images/help",
									publicPath: "/images/help",
								}),
								image_alt: fields.text({
									label: "Bild Alt",
									description: "Der Alt-Text für das Bild",
								}),
							},
						}),
						ImageGallery: wrapper({
							label: "Gallerie",
							description: "Eine Gallerie mit Bildern",
							schema: {
								images: fields.array(
									fields.object(
										{
											image: fields.image({
												label: "Bild",
												directory: "public/images/help",
												publicPath: "/images/help",
											}),
											alt: fields.text({
												label: "Alt",
											}),
											caption: fields.text({
												label: "Caption",
											}),
										},
										{
											label: "Bilder",
										},
									),
								),
							},
						}),
						SingleImage: wrapper({
							label: "Einzelbild",
							description: "Ein einzelnes Bild",
							schema: {
								image: fields.object(
									{
										image: fields.image({
											label: "Bild",
											directory: "public/images/help",
											publicPath: "/images/help",
										}),
										alt: fields.text({
											label: "Alt",
										}),
										caption: fields.text({
											label: "Caption",
										}),
									},
									{
										label: "Einzelbild",
									},
								),
							},
						}),
					},
				}),
			},
		}),
		project: singleton({
			label: "Projekt",
			path: "src/content/project",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/project",
							publicPath: "/images/project",
						},
					},
					components: {
						TextImage: wrapper({
							label: "Text und Bild",
							description: "Ein Container mit Text und einem Bild",
							schema: {
								text: fields.text({
									label: "Text",
									description: "Der Text, der neben dem Bild angezeigt wird.",
									validation: {
										length: {
											min: 20,
										},
									},
								}),
								image: fields.image({
									label: "Bild",
									directory: "public/images/project",
									publicPath: "/images/project",
								}),
								image_alt: fields.text({
									label: "Bild Alt",
									description: "Der Alt-Text für das Bild",
								}),
							},
						}),
						ImageGallery: wrapper({
							label: "Gallerie",
							description: "Eine Gallerie mit Bildern",
							schema: {
								images: fields.array(
									fields.object(
										{
											image: fields.image({
												label: "Bild",
												directory: "public/images/project",
												publicPath: "/images/project",
											}),
											alt: fields.text({
												label: "Alt",
											}),
											caption: fields.text({
												label: "Caption",
											}),
										},
										{
											label: "Bilder",
										},
									),
								),
							},
						}),
						SingleImage: wrapper({
							label: "Einzelbild",
							description: "Ein einzelnes Bild",
							schema: {
								image: fields.object(
									{
										image: fields.image({
											label: "Bild",
											directory: "public/images/project",
											publicPath: "/images/project",
										}),
										alt: fields.text({
											label: "Alt",
										}),
										caption: fields.text({
											label: "Caption",
										}),
									},
									{
										label: "Einzelbild",
									},
								),
							},
						}),
					},
				}),
			},
		}),
	},
	collections: {
		publications: collection({
			label: "Publikationen",
			slugField: "title",
			parseSlugForSort: (slug) => {
				return slug + "-" + String(new Date().getTime());
			},
			path: "src/content/publications/*",
			format: { data: "json" },
			schema: {
				title: fields.slug({
					name: { label: "Titel", description: "Publikationstitel" },
					slug: {
						label: "URL und Dateiname",
						description: "Der Name der Datei und der URL",
					},
				}),
				publicationUnstructured: fields.text({
					label: "Publikation unstrukturiert",
					multiline: true,
				}),
				authors: fields.array(
					fields.object({
						firstName: fields.text({ label: "Vorname" }),
						lastName: fields.text({ label: "Nachname" }),
						middleName: fields.text({ label: "Zweiter Vorname" }),
					}),
					{
						label: "Autor(en)",
					},
				),
				year: fields.text({
					label: "Jahr",
				}),
				publishedIn: fields.text({
					label: "Publiziert in",
				}),
				publishers: fields.text({
					label: "Verlag",
				}),
				pubPlace: fields.text({
					label: "Erscheinungsort",
				}),
				volume: fields.text({
					label: "Band",
				}),
				pages: fields.text({
					label: "Seiten",
				}),
				url: fields.text({
					label: "URL",
				}),
				urldate: fields.date({
					label: "Zugriffsdatum",
				}),
			},
		}),
		presentations: collection({
			label: "Präsentationen",
			slugField: "title",
			parseSlugForSort: (slug) => {
				return slug + "-" + String(new Date().getTime());
			},
			path: "src/content/presentations/*",
			format: { data: "json" },
			schema: {
				title: fields.slug({
					name: { label: "Titel" },
				}),
				presentationUnstructured: fields.text({
					label: "Präsentationen unstrukturiert",
					multiline: true,
				}),
				type: fields.select({
					label: "Typ",
					options: [
						{ label: "Workshop", value: "Workshop" },
						{ label: "Vortrag", value: "Vortrag" },
						{ label: "Poster", value: "Poster" },
					],
					defaultValue: "Vortrag",
				}),
				authors: fields.array(
					fields.object({
						firstName: fields.text({ label: "Vorname" }),
						lastName: fields.text({ label: "Nachname" }),
						middleName: fields.text({ label: "Zweiter Vorname" }),
					}),
					{
						label: "Autor(en)",
					},
				),
				date: fields.date({
					label: "Datum",
				}),
				place: fields.text({
					label: "Ort",
				}),
				url: fields.text({
					label: "URL",
				}),
			},
		}),
		events: collection({
			label: "Events",
			slugField: "title",
			parseSlugForSort: (slug) => {
				return slug + "-" + String(new Date().getTime());
			},
			path: "src/content/events/*",
			entryLayout: "content",
			format: {
				contentField: "content",
			},
			schema: {
				type: fields.select({
					label: "Typ",
					options: [
						{ label: "Workshop", value: "Workshop" },
						{ label: "Vortrag", value: "Vortrag" },
						{ label: "Konferenz", value: "Konferenz" },
						{ label: "Buchpräsentation", value: "Buchpräsentation" },
					],
					defaultValue: "Vortrag",
				}),
				authors: fields.array(
					fields.object({
						firstName: fields.text({ label: "Vorname" }),
						lastName: fields.text({ label: "Nachname" }),
						middleName: fields.text({ label: "Zweiter Vorname" }),
					}),
					{
						label: "Autor(en)",
					},
				),
				title: fields.slug({
					name: { label: "Titel" },
				}),
				date: fields.date({
					label: "Datum",
				}),
				place: fields.text({
					label: "Ort",
				}),
				url: fields.text({
					label: "URL",
				}),
				image: fields.image({
					label: "Titelbild",
					directory: "public/images/events/title",
					publicPath: "/images/events/title",
				}),
				content: fields.mdx({
					label: "Content",
					options: {
						image: {
							directory: "public/images/news/content",
							publicPath: "/images/news/content",
						},
					},
					components: {
						TextImage: wrapper({
							label: "Text and Image",
							description: "A container with text and an image",
							// ContentView: (props) => {
							// 	return `<div>
							// 			${props.value.text}
							// 			<img src="${props.value.image?.filename}" alt="${props.value.image_alt}" />
							// 		</div>`;
							// },
							schema: {
								text: fields.text({
									label: "Text",
									description: "The text to display next to the image.",
									validation: {
										length: {
											min: 20,
										},
									},
								}),
								image: fields.image({
									label: "Image",
									directory: "public/images/events/component",
									publicPath: "/images/events/component",
								}),
								image_alt: fields.text({
									label: "Image Alt",
									description: "The alt text for the image",
								}),
							},
						}),
						ImageGallery: wrapper({
							label: "Gallerie",
							description: "Eine Gallerie mit Bildern",
							// ContentView: (props) => {
							// 	const images = props.value.images;
							// 	if (!images.image) return null;
							// 	return `<div>
							// 			<img src="${images.image.filename}" alt="${images.alt}" />
							// 		</div>`;
							// },
							schema: {
								images: fields.array(
									fields.object(
										{
											image: fields.image({
												label: "Bild",
												directory: "public/images/events/component",
												publicPath: "/images/events/component",
											}),
											alt: fields.text({
												label: "Alt",
											}),
											caption: fields.text({
												label: "Caption",
											}),
										},
										{
											label: "Bilder",
										},
									),
								),
							},
						}),
						SingleImage: wrapper({
							label: "Einzelbild",
							description: "Ein einzelnes Bild",
							schema: {
								image: fields.object(
									{
										image: fields.image({
											label: "Bild",
											directory: "public/images/news/component",
											publicPath: "/images/news/component",
										}),
										alt: fields.text({
											label: "Alt",
										}),
										caption: fields.text({
											label: "Caption",
										}),
									},
									{
										label: "Einzelbild",
									},
								),
							},
						}),
					},
				}),
			},
		}),
		news: collection({
			label: "Neuigkeiten",
			slugField: "title",
			parseSlugForSort: (slug) => {
				return slug + "-" + String(new Date().getTime());
			},
			path: "src/content/news/*",
			entryLayout: "content",
			format: {
				contentField: "content",
			},
			schema: {
				authors: fields.array(
					fields.object({
						firstName: fields.text({ label: "Vorname" }),
						lastName: fields.text({ label: "Nachname" }),
						middleName: fields.text({ label: "Zweiter Vorname" }),
					}),
					{
						label: "Autor(en)",
					},
				),
				title: fields.slug({
					name: { label: "Titel" },
				}),
				date: fields.date({
					label: "Datum",
				}),
				url: fields.text({
					label: "URL",
				}),
				image: fields.image({
					label: "Titelbild",
					directory: "public/images/news/title",
					publicPath: "/images/news/title",
				}),
				content: fields.mdx({
					label: "Content",
					options: {
						image: {
							directory: "public/images/news/content",
							publicPath: "/images/news/content",
						},
					},
					components: {
						TextImage: wrapper({
							label: "Text and Image",
							description: "A container with text and an image",
							schema: {
								text: fields.text({
									label: "Text",
									description: "The text to display next to the image.",
									validation: {
										length: {
											min: 20,
										},
									},
								}),
								image: fields.image({
									label: "Image",
									directory: "public/images/news/component",
									publicPath: "/images/news/component",
								}),
								image_alt: fields.text({
									label: "Image Alt",
									description: "The alt text for the image",
								}),
							},
						}),
						ImageGallery: wrapper({
							label: "Gallerie",
							description: "Eine Gallerie mit Bildern",
							// ContentView: (props) => {
							// 	const images = props.value.images;
							// 	if (!images.image) return null;
							// 	return `<div>
							// 			<img src="${images.image.filename}" alt="${images.alt}" />
							// 		</div>`;
							// },
							schema: {
								images: fields.array(
									fields.object(
										{
											image: fields.image({
												label: "Bild",
												directory: "public/images/events/component",
												publicPath: "/images/events/component",
											}),
											alt: fields.text({
												label: "Alt",
											}),
											caption: fields.text({
												label: "Caption",
											}),
										},
										{
											label: "Bilder",
										},
									),
								),
							},
						}),
						SingleImage: wrapper({
							label: "Einzelbild",
							description: "Ein einzelnes Bild",
							schema: {
								image: fields.object(
									{
										image: fields.image({
											label: "Bild",
											directory: "public/images/news/component",
											publicPath: "/images/news/component",
										}),
										alt: fields.text({
											label: "Alt",
										}),
										caption: fields.text({
											label: "Caption",
										}),
									},
									{
										label: "Einzelbild",
									},
								),
							},
						}),
					},
				}),
			},
		}),
	},
});
