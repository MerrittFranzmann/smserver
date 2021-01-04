import SwiftUI

struct SettingsView: View {
	let settings = Settings.shared()
	
	var grey_box = Color("BeginningBlur")

	private let picker_options: [String] = ["Dark", "Light", "Nord"]

	private let cl_red = 0.60
	private let cl_grn = 0.65

	@State private var display_ssl_alert: Bool = false
	@State private var display_port_alert: Bool = false

	@State private var rect: CGRect = CGRect()

	private func resetDefaults() {
		let domain = Bundle.main.bundleIdentifier!
		UserDefaults.standard.removePersistentDomain(forName: domain)
	}

	var body: some View {

		let chats_binding = Binding<Int>(get: {
			self.settings.default_num_chats
		}, set: {
			self.settings.default_num_chats = Int($0)
			UserDefaults.standard.setValue(Int($0), forKey: "num_chats")
		})

		let messages_binding = Binding<Int>(get: {
			self.settings.default_num_messages
		}, set: {
			self.settings.default_num_messages = Int($0)
			UserDefaults.standard.setValue(Int($0), forKey: "num_messages")
		})

		let photos_binding = Binding<Int>(get: {
			self.settings.default_num_photos
		}, set: {
			self.settings.default_num_photos = Int($0)
			UserDefaults.standard.setValue(Int($0), forKey: "num_photos")
		})

		let socket_binding = Binding<Int>(get: {
			self.settings.socket_port
		}, set: {
			if String($0) == self.settings.server_port {
				self.display_port_alert = true
			} else {
				self.settings.socket_port = Int($0)
				UserDefaults.standard.setValue(Int($0), forKey: "socket_port")
			}
		})

		let theme_binding = Binding<Int>(get: {
			self.settings.light_theme ? 1 : (self.settings.nord_theme ? 2 : 0)
		}, set: {
			self.settings.light_theme = $0 == 1
			self.settings.nord_theme = $0 == 2
			UserDefaults.standard.setValue(self.settings.light_theme, forKey: "light_theme")
			UserDefaults.standard.setValue(self.settings.nord_theme, forKey: "nord_theme")
		})

		let subject_binding = Binding<Bool>(get: {
			self.settings.subjects_enabled
		}, set: {
			self.settings.subjects_enabled = $0
			UserDefaults.standard.setValue($0, forKey: "subjects_enabled")
		})

		let typing_binding = Binding<Bool>(get: {
			self.settings.send_typing
		}, set: {
			self.settings.send_typing = $0
			UserDefaults.standard.setValue($0, forKey: "send_typing")
		})

		let read_binding = Binding<Bool>(get: {
			self.settings.mark_when_read
		}, set: {
			self.settings.mark_when_read = $0
			UserDefaults.standard.setValue($0, forKey: "mark_when_read")
		})

		let auth_binding = Binding<Bool>(get: {
			self.settings.require_authentication
		}, set: {
			self.settings.require_authentication = $0
			UserDefaults.standard.setValue($0, forKey: "require_auth")
		})

		let contacts_binding = Binding<Bool>(get: {
			self.settings.combine_contacts
		}, set: {
			self.settings.combine_contacts = $0
			UserDefaults.standard.setValue($0, forKey: "combine_contacts")
		})

		let debug_binding = Binding<Bool>(get: {
			self.settings.debug
		}, set: {
			self.settings.debug = $0
			UserDefaults.standard.setValue($0, forKey: "debug")
		})

		let background_binding = Binding<Bool>(get: {
			self.settings.background
		}, set: {
			self.settings.background = $0
			UserDefaults.standard.setValue($0, forKey: "enable_backgrounding")
		})

		let secure_binding = Binding<Bool>(get: {
			self.settings.is_secure
		}, set: {
			self.settings.is_secure = $0
			UserDefaults.standard.setValue($0, forKey: "is_secure")
			self.display_ssl_alert = true
		})

		let override_binding = Binding<Bool>(get: {
			self.settings.override_no_wifi
		}, set: {
			self.settings.override_no_wifi = $0
			UserDefaults.standard.setValue($0, forKey: "override_no_wifi")
		})

		let load_binding = Binding<Bool>(get: {
			self.settings.start_on_load
		}, set: {
			self.settings.start_on_load = $0
			UserDefaults.standard.setValue($0, forKey: "start_on_load")
		})

		return ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				Text("Settings")
					.font(.largeTitle)

				Spacer().frame(height: 8)

				Text("Load values")
					.font(.headline)

				Section {
					VStack {

						HStack {
							Text("Initial number of chats to load")
							Spacer()
							TextField("Chats", value: chats_binding, formatter: NumberFormatter())
								.textFieldStyle(RoundedBorderTextFieldStyle())
								.frame(width: 60)
						}

						HStack {
							Text("Initial number of messages to load")
							Spacer()
							TextField("Messages", value: messages_binding, formatter: NumberFormatter())
								.textFieldStyle(RoundedBorderTextFieldStyle())
								.frame(width: 60)
						}

						HStack {
							Text("Initial number of photos to load")
							Spacer()
							TextField("Photos", value: photos_binding, formatter: NumberFormatter())
								.textFieldStyle(RoundedBorderTextFieldStyle())
								.frame(width: 60)
						}

						HStack {
							Text("Websocket port")
							Spacer()
							TextField("Port", value: socket_binding, formatter: NumberFormatter())
								.textFieldStyle(RoundedBorderTextFieldStyle())
								.frame(width: 60)
						}
					}
				}.padding(10)
				.background(grey_box)
				.cornerRadius(8)

				Spacer().frame(height: 14)

				HStack {
					Text("Theme")
						.font(.headline)

					Spacer().frame(width: 20)

					Picker(selection: theme_binding, label: Text("")) {
						ForEach(0..<self.picker_options.count, id: \.self) { i in
							return Text(self.picker_options[i]).tag(i)
						}
					}.pickerStyle(SegmentedPickerStyle())

				}

				Spacer().frame(height: 14)

				Section {

					Text("Web interface Settings")
						.font(.headline)

					Section {
						VStack(spacing: 8) {

							Toggle("Enable subject line", isOn: subject_binding)
							Toggle("Send typing indicators", isOn: typing_binding)
							Toggle("Automatically mark as read", isOn: read_binding)
							Toggle("Require Authentication", isOn: auth_binding)
							Toggle("Merge contact addresses (experimental)", isOn: contacts_binding)

						}
					}.padding(10)
					.background(grey_box)
					.cornerRadius(8)

					Spacer().frame(height: 8)

					Text("Miscellaneous")
						.font(.headline)

					Section {
						VStack(spacing: 8) {

							Toggle("Toggle debug", isOn: debug_binding)
							Toggle("Enable backgrounding", isOn: background_binding)
							Toggle("Enable SSL", isOn: secure_binding)
							Toggle("Allow operation off of Wifi", isOn: override_binding)
							Toggle("Start server on app launch", isOn: load_binding)

						}
					}.padding(10)
					.background(grey_box)
					.cornerRadius(8)

				}.alert(isPresented: $display_ssl_alert, content: {
					Alert(title: Text("Restart"), message: Text("Please restart the app for your new settings to take effect"))
				})
				.alert(isPresented: $display_port_alert, content: {
					Alert(title: Text("Error"), message: Text("The websocket port must be different from the main server port. Please change it to fix this."))
				})

				Section {
					VStack {
						Button(action: {
							let url = URL.init(string: "https://github.com/iandwelker/smserver/blob/master/docs/API.md")
							guard let github_url = url, UIApplication.shared.canOpenURL(github_url) else { return }
							UIApplication.shared.open(github_url)
						}) {
							ZStack {
								LinearGradient(
									gradient: Gradient(
										colors: [
											Color.init(red: cl_red, green: cl_grn, blue: (Double(rect.minY) - 240.0) / 255),
											Color.init(red: cl_red, green: cl_grn, blue: (Double(rect.minY) - 270.0) / 255)
										]
									),
									startPoint: .topLeading, endPoint: .bottomTrailing
								).mask(
									HStack {
										Text("View API Documentation")
											.aspectRatio(contentMode: .fill)
										Spacer()
										Image(systemName: "doc.text")
											.resizable()
											.aspectRatio(contentMode: .fit)
									}
								).frame(height: 20)
							}
						}

						Spacer().frame(height: 20)

						Button(action: {
							let url = URL.init(string: "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=K3A6WVKT54PH4&item_name=Tweak%2FApplication+Development&currency_code=USD")
							guard let github_url = url, UIApplication.shared.canOpenURL(github_url) else { return }
							UIApplication.shared.open(github_url)
						}) {
							ZStack {
								LinearGradient(
									gradient: Gradient(
										colors: [
											Color.init(red: cl_red, green: cl_grn, blue: (Double(rect.minY) - 260.0) / 255),
											Color.init(red: cl_red, green: cl_grn, blue: (Double(rect.minY) - 290.0) / 255)
										]
									),
									startPoint: .topLeading, endPoint: .bottomTrailing
								).mask(
									HStack {
										Text("Donate to support SMServer")
										Spacer()
										Image(systemName: "link")
											.resizable()
											.aspectRatio(contentMode: .fit)
									}
								).frame(height: 20)
							}
						}

						Spacer().frame(height: 20)

						Button(action: {
							self.resetDefaults()
						}) {
							ZStack {
								LinearGradient(
									gradient: Gradient(
										colors: [
											Color.init(red: cl_red, green: cl_grn, blue: (Double(rect.minY) - 280.0) / 255),
											Color.init(red: cl_red, green: cl_grn, blue: (Double(rect.minY) - 310.0) / 255)
										]
									),
									startPoint: .topLeading, endPoint: .bottomTrailing
								).mask(
									HStack {
										Text("Reset Settings to Default")
										Spacer()
										Image(systemName: "arrow.clockwise")
											.resizable()
											.aspectRatio(contentMode: .fit)
									}
								).frame(height: 20)
							}
						}

					}.padding(10)
					.background(grey_box)
					.cornerRadius(8)
					.background(GeometryGetter(rect: $rect))

					Text("Compatible with libSMServer 0.6.0")
						.font(.callout)
						.foregroundColor(.gray)
				}

			}.padding()
		}
	}
}

struct GeometryGetter: View {
	@Binding var rect: CGRect

	var body: some View {
		return GeometryReader { geometry in
			self.makeView(geometry: geometry)
		}
	}

	func makeView(geometry: GeometryProxy) -> some View {
		DispatchQueue.main.async {
			self.rect = geometry.frame(in: .global)
		}

		return Rectangle().fill(Color.clear)
	}
}