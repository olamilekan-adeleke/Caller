// ShareSheet.swift
//
// Created on 15/11/2025.
// Copyright (c) 2025 and Confidential to Sama All rights reserved.

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let excludedActivityTypes: [UIActivity.ActivityType]?
    let onComplete: (() -> Void)?

    init(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil, onComplete: (() -> Void)? = nil) {
        self.items = items
        self.excludedActivityTypes = excludedActivityTypes
        self.onComplete = onComplete
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onComplete: onComplete)
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )

        // Set primaryBlue color for bar button items to match app styling
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: Constants.Colors.primaryBlue], for: .normal)

        if let excludedActivityTypes = excludedActivityTypes {
            activityViewController.excludedActivityTypes = excludedActivityTypes
        }

        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            context.coordinator.onComplete?()
        }

        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No-op: Share sheet is stateless
    }

    class Coordinator {
        let onComplete: (() -> Void)?

        init(onComplete: (() -> Void)?) {
            self.onComplete = onComplete
        }
    }
}
