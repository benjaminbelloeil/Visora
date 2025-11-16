//
//  HelpSupportView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct HelpSupportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var selectedFAQ: FAQ?
    @State private var showContactForm = false
    
    var body: some View {
        List {
            // Quick Actions
            Section {
                Button {
                    showContactForm = true
                } label: {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.actionColor)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Contact Support")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.textColor)
                            Text("Get help from our team")
                                .font(.caption)
                                .foregroundColor(.subTextColor)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Link(destination: URL(string: "https://visora.com/tutorials")!) {
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.blue)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Video Tutorials")
                                .font(.body)
                                .fontWeight(.medium)
                            Text("Learn how to use Visora")
                                .font(.caption)
                                .foregroundColor(.subTextColor)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
            } header: {
                Text("Get Help")
            }
            
            // FAQs
            Section {
                ForEach(filteredFAQs) { faq in
                    Button {
                        selectedFAQ = faq
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(faq.question)
                                    .font(.body)
                                    .foregroundColor(.textColor)
                                    .multilineTextAlignment(.leading)
                                
                                Text(faq.category)
                                    .font(.caption)
                                    .foregroundColor(.actionColor)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.subTextColor)
                        }
                    }
                }
            } header: {
                Text("Frequently Asked Questions")
            }
            
            // Resources
            Section {
                Link(destination: URL(string: "https://visora.com/community")!) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.actionColor)
                        Text("Community Forum")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Link(destination: URL(string: "https://visora.com/blog")!) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.actionColor)
                        Text("Blog & Tips")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                NavigationLink {
                    ReportBugView()
                } label: {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.actionColor)
                        Text("Report a Bug")
                    }
                }
            } header: {
                Text("Resources")
            }
            
            // Contact Info
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.actionColor)
                        Text("support@visora.com")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.actionColor)
                        Text("Response time: 24-48 hours")
                            .font(.subheadline)
                            .foregroundColor(.subTextColor)
                    }
                }
            } header: {
                Text("Contact Information")
            }
        }
        .searchable(text: $searchText, prompt: "Search FAQs")
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .sheet(item: $selectedFAQ) { faq in
            NavigationStack {
                FAQDetailView(faq: faq)
            }
        }
        .sheet(isPresented: $showContactForm) {
            NavigationStack {
                ContactSupportView()
            }
        }
    }
    
    private var filteredFAQs: [FAQ] {
        if searchText.isEmpty {
            return FAQ.allFAQs
        } else {
            return FAQ.allFAQs.filter {
                $0.question.localizedCaseInsensitiveContains(searchText) ||
                $0.answer.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct FAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let category: String
    
    static let allFAQs: [FAQ] = [
        FAQ(
            question: "How does AI monument recognition work?",
            answer: "Visora uses Google's Gemini AI to analyze your photos and identify monuments, landmarks, and historical sites. The AI examines visual features, architectural details, and contextual clues to provide accurate identification and historical information.",
            category: "Features"
        ),
        FAQ(
            question: "Why isn't my location being detected correctly?",
            answer: "Visora uses multiple methods to determine location:\n\n1. Photo EXIF data (if available)\n2. AI-identified location geocoding\n3. Device GPS (fallback)\n\nMake sure Location Services are enabled in Settings > Privacy > Location Services. If your iPhone photos don't contain EXIF data, Visora will use the AI-identified location to place the photo on the map.",
            category: "Location"
        ),
        FAQ(
            question: "Can I use Visora offline?",
            answer: "Some features work offline:\n\n✓ View saved photos and memories\n✓ Browse your calendar\n✓ Access saved locations on the map\n\n✗ AI monument recognition requires internet\n✗ Geocoding requires internet\n✗ Map tiles require internet\n\nWe recommend using Visora with an internet connection for the best experience.",
            category: "Features"
        ),
        FAQ(
            question: "How do I delete a photo from my calendar?",
            answer: "To delete a photo:\n\n1. Open the Calendar view\n2. Tap on the date with the photo you want to delete\n3. Tap on the photo to view details\n4. Swipe left on the photo\n5. Tap the Delete button\n\nNote: This only removes the photo from Visora, not from your iPhone's photo library.",
            category: "Usage"
        ),
        FAQ(
            question: "Is my data private and secure?",
            answer: "Yes! Your privacy is our top priority:\n\n• Photos are stored locally on your device\n• AI analysis is processed securely\n• We don't sell your data to third parties\n• You can delete your account anytime\n\nFor more details, see our Privacy Policy in Settings.",
            category: "Privacy"
        ),
        FAQ(
            question: "What monuments can Visora recognize?",
            answer: "Visora can identify thousands of monuments and landmarks worldwide, including:\n\n• UNESCO World Heritage Sites\n• Famous historical monuments\n• Museums and cultural sites\n• Religious buildings and temples\n• Modern architectural landmarks\n• Natural wonders\n\nThe AI is constantly learning and improving its recognition capabilities.",
            category: "Features"
        ),
        FAQ(
            question: "How can I improve monument recognition accuracy?",
            answer: "For best results:\n\n✓ Take clear, well-lit photos\n✓ Capture distinctive features of the monument\n✓ Avoid heavily cropped or filtered images\n✓ Include the full structure when possible\n✓ Ensure stable internet connection during analysis\n\nThe AI works best with photos that clearly show the monument's unique characteristics.",
            category: "Tips"
        ),
        FAQ(
            question: "Can I export my travel data?",
            answer: "Yes! You can export your data:\n\n1. Go to Profile > Settings > Privacy\n2. Tap 'Download My Data'\n3. Choose export format (JSON or CSV)\n4. Your data will be prepared and downloaded\n\nThe export includes photos, locations, dates, and AI analysis results.",
            category: "Data"
        )
    ]
}

struct FAQDetailView: View {
    @Environment(\.dismiss) var dismiss
    let faq: FAQ
    @State private var wasHelpful: Bool?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Category Badge
                Text(faq.category)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.actionColor)
                    .cornerRadius(12)
                
                // Question
                Text(faq.question)
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Answer
                Text(faq.answer)
                    .font(.body)
                    .foregroundColor(.textColor)
                    .lineSpacing(6)
                
                Divider()
                    .padding(.vertical)
                
                // Feedback
                VStack(alignment: .leading, spacing: 12) {
                    Text("Was this helpful?")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 12) {
                        Button {
                            wasHelpful = true
                        } label: {
                            HStack {
                                Image(systemName: wasHelpful == true ? "hand.thumbsup.fill" : "hand.thumbsup")
                                Text("Yes")
                            }
                            .foregroundColor(wasHelpful == true ? .white : .actionColor)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(wasHelpful == true ? Color.actionColor : Color.actionColor.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        Button {
                            wasHelpful = false
                        } label: {
                            HStack {
                                Image(systemName: wasHelpful == false ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                Text("No")
                            }
                            .foregroundColor(wasHelpful == false ? .white : .subTextColor)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(wasHelpful == false ? Color.subTextColor : Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    
                    if wasHelpful != nil {
                        Text(wasHelpful! ? "Thanks for your feedback!" : "We're sorry this didn't help. Please contact support for more assistance.")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct ContactSupportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var message = ""
    @State private var category = "General"
    @State private var showSuccess = false
    
    let categories = ["General", "Bug Report", "Feature Request", "Account", "Privacy", "Other"]
    
    var body: some View {
        Form {
            Section {
                TextField("Your Name", text: $name)
                TextField("Email Address", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            } header: {
                Text("Contact Information")
            }
            
            Section {
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                
                TextField("Subject", text: $subject)
            } header: {
                Text("Issue Details")
            }
            
            Section {
                TextEditor(text: $message)
                    .frame(minHeight: 150)
            } header: {
                Text("Message")
            } footer: {
                Text("Please provide as much detail as possible to help us assist you better.")
            }
            
            Section {
                Button {
                    submitFeedback()
                } label: {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Message Sent", isPresented: $showSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Thank you for contacting us! We'll get back to you within 24-48 hours.")
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !subject.isEmpty && !message.isEmpty
    }
    
    private func submitFeedback() {
        // In a real app, send this to your backend
        showSuccess = true
    }
}

struct ReportBugView: View {
    @Environment(\.dismiss) var dismiss
    @State private var bugTitle = ""
    @State private var bugDescription = ""
    @State private var stepsToReproduce = ""
    @State private var severity = "Medium"
    @State private var showSuccess = false
    
    let severityLevels = ["Low", "Medium", "High", "Critical"]
    
    var body: some View {
        Form {
            Section {
                TextField("Bug Title", text: $bugTitle)
                
                Picker("Severity", selection: $severity) {
                    ForEach(severityLevels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
            } header: {
                Text("Bug Information")
            }
            
            Section {
                TextEditor(text: $bugDescription)
                    .frame(minHeight: 100)
            } header: {
                Text("Description")
            } footer: {
                Text("Describe what happened and what you expected to happen")
            }
            
            Section {
                TextEditor(text: $stepsToReproduce)
                    .frame(minHeight: 100)
            } header: {
                Text("Steps to Reproduce")
            } footer: {
                Text("Help us recreate the issue by listing the steps")
            }
            
            Section {
                Button {
                    submitBugReport()
                } label: {
                    Text("Submit Bug Report")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Report a Bug")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Bug Report Submitted", isPresented: $showSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Thank you for helping us improve Visora! We'll investigate this issue.")
        }
    }
    
    private var isFormValid: Bool {
        !bugTitle.isEmpty && !bugDescription.isEmpty
    }
    
    private func submitBugReport() {
        // In a real app, send this to your backend
        showSuccess = true
    }
}

#Preview {
    NavigationStack {
        HelpSupportView()
    }
}
