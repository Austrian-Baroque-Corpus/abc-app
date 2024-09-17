import {
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
		corpus: singleton({
			label: "Corpus",
			path: "src/content/corpus/",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/corpus",
							publicPath: "/images/corpus",
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
									directory: "public/images/corpus",
									publicPath: "/images/corpus",
								}),
								image_alt: fields.text({
									label: "Bild Alt",
									description: "Der Alt-Text für das Bild",
								}),
								link: fields.text({
									label: "Link",
									description: "Der Link, der unter dem Text angezeigt wird.",
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
												directory: "public/images/corpus",
												publicPath: "/images/corpus",
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
		annotation: singleton({
			label: "Annotation",
			path: "src/content/annotation/",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/annotation",
							publicPath: "/images/annotation",
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
								}),
								image: fields.image({
									label: "Bild",
									directory: "public/images/annotation",
									publicPath: "/images/annotation",
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
												directory: "public/images/annotation",
												publicPath: "/images/annotation",
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
											directory: "public/images/annotation",
											publicPath: "/images/annotation",
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
		nutzung: singleton({
			label: "Nutzung",
			path: "src/content/nutzung/",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/nutzung",
							publicPath: "/images/nutzung",
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
									directory: "public/images/nutzung",
									publicPath: "/images/nutzung",
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
												directory: "public/images/nutzung",
												publicPath: "/images/nutzung",
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
											directory: "public/images/nutzung",
											publicPath: "/images/nutzung",
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
		cite: singleton({
			label: "Zitierung, Kontakt",
			path: "src/content/cite/",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/cite",
							publicPath: "/images/cite",
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
									directory: "public/images/cite",
									publicPath: "/images/cite",
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
												directory: "public/images/cite",
												publicPath: "/images/cite",
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
											directory: "public/images/cite",
											publicPath: "/images/cite",
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
		ueber_uns: singleton({
			label: "Über uns",
			path: "src/content/ueber_uns/",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/ueber_uns",
							publicPath: "/images/ueber_uns",
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
									directory: "public/images/ueber_uns",
									publicPath: "/images/ueber_uns",
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
												directory: "public/images/ueber_uns",
												publicPath: "/images/ueber_uns",
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
											directory: "public/images/ueber_uns",
											publicPath: "/images/ueber_uns",
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
		dank: singleton({
			label: "Dank",
			path: "src/content/dank/",
			format: { contentField: "content" },
			schema: {
				title: fields.text({
					label: "Titel",
				}),
				content: fields.mdx({
					label: "Inhalt",
					options: {
						image: {
							directory: "public/images/dank",
							publicPath: "/images/dank",
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
								}),
								image: fields.image({
									label: "Bild",
									directory: "public/images/dank",
									publicPath: "/images/dank",
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
												directory: "public/images/dank",
												publicPath: "/images/dank",
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
											directory: "public/images/dank",
											publicPath: "/images/dank",
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
