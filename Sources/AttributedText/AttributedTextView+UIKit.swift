#if canImport(UIKit) && !os(watchOS)

    import SwiftUI

    @available(iOS 14.0, tvOS 14.0, *)
    class AttributedTextView: UIView, UITextViewDelegate {
        var preferredMaxLayoutWidth: CGFloat = 0 {
            didSet {
                guard preferredMaxLayoutWidth != oldValue else { return }
                invalidateIntrinsicContentSize()
            }
        }

        var attributedText: NSAttributedString {
            get { textView.attributedText }
            set {
                textView.attributedText = newValue
                invalidateIntrinsicContentSize()
            }
        }

        var numberOfLines: Int {
            get { textView.textContainer.maximumNumberOfLines }
            set {
                textView.textContainer.maximumNumberOfLines = newValue
                invalidateIntrinsicContentSize()
            }
        }

        var lineBreakMode: NSLineBreakMode {
            get { textView.textContainer.lineBreakMode }
            set {
                textView.textContainer.lineBreakMode = newValue
                invalidateIntrinsicContentSize()
            }
        }

        var openURL: OpenURLAction?

        override var intrinsicContentSize: CGSize {
            if let size = cachedIntrinsicContentSize { return size }

            let maxWidth = preferredMaxLayoutWidth > 0 ? preferredMaxLayoutWidth : bounds.width
            guard maxWidth > 0 else { return textView.intrinsicContentSize }

            let size = textView.sizeThatFits(CGSize(width: maxWidth, height: .infinity))
            cachedIntrinsicContentSize = size

            return size
        }

        private let textView = UITextView()
        private var cachedIntrinsicContentSize: CGSize?

        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            textView.frame = bounds
        }

        override func invalidateIntrinsicContentSize() {
            cachedIntrinsicContentSize = nil
            super.invalidateIntrinsicContentSize()
        }

        func textView(
            _: UITextView,
            shouldInteractWith URL: URL,
            in _: NSRange,
            interaction _: UITextItemInteraction
        ) -> Bool {
            openURL?(URL)
            return false
        }

        private func setUp() {
            addSubview(textView)

            backgroundColor = .clear

            textView.textContainerInset = .zero
            #if !os(tvOS)
                textView.isEditable = false
            #endif
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            textView.textContainer.lineFragmentPadding = 0
            textView.delegate = self
        }
    }

#endif