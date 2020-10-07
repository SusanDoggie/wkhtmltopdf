//
//  Parameter.swift
//
//  The MIT License
//  Copyright (c) 2015 - 2020 Susan Cheng. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

extension WKHtml2Pdf {
    
    public enum Orientation: String {
        case Portrait, Landscape
    }

    public enum Handler: String {
        case abort, ignore, skip
    }
    
    public enum PaperSize: String {
        case A0, A1, A2, A3, A4, A5, A6, A7, A8, A9
        case B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10
        case C5E
        case Comm10E
        case DLE
        case Executive
        case Folio
        case Ledger
        case Legal
        case Letter
        case Tabloid
    }
    
    public enum Parameter: CustomStringConvertible, Equatable {
        
        /// -q, --quiet Be less verbose, maintained for backwards compatibility; Same as using --log-level none
        case quiet
        /// -s, --page-size <Size> Set paper size to: A4, Letter, etc. (default A4)
        case paperSize(PaperSize)
        /// -g, --grayscale PDF will be generated in grayscale
        case grayscale
        /// -l, --lowquality Generates lower quality pdf/ps. Useful to shrink the result document space
        case lowQuality
        /// -O, --orientation <orientation> Set orientation to Landscape or Portrait (default Portrait)
        case orientation(Orientation)
        /// -T, --margin-top <unitreal> Set the page top margin
        case topMargin(Float)
        /// -R, --margin-right <unitreal> Set the page right margin (default 10mm)
        case rightMargin(Float)
        /// -B, --margin-bottom <unitreal> Set the page bottom margin
        case bottomMargin(Float)
        /// -L, --margin-left <unitreal> Set the page left margin (default 10mm)
        case leftMargin(Float)
        /// --page-height <unitreal> Page height
        case pageHeight(Float)
        /// --page-width <unitreal> Page width
        case pageWidth(Float)
        case replace(name: String, value: String)
        /// --disable-dotted-lines Do not use dotted lines in the toc
        case disableDottedLines
        /// --toc-header-text <text> The header text of the toc (default Table of Contents)
        case tocHeaderText(String)
        /// --toc-level-indentation <width> For each level of headings in the toc indent by this length (default 1em)
        case tocLevelIndentation(String)
        /// --disable-toc-links Do not link from toc to sections
        case disableTocLinks
        /// --toc-text-size-shrink <real> For each level of headings in the toc the font is scaled by this factor (default 0.8)
        case tocTextSizeShrink(Float)
        
        public var key: String {
            switch self {
            case .quiet: return "--quiet"
            case .paperSize: return "-s"
            case .grayscale: return "-g"
            case .lowQuality: return "-l"
            case .orientation: return "-O"
            case .topMargin: return "-T"
            case .rightMargin: return "-R"
            case .bottomMargin: return "-B"
            case .leftMargin: return "-L"
            case .pageHeight: return "--page-height"
            case .pageWidth: return "--page-width"
            case .replace: return "--replace"
            case .disableDottedLines: return "--disable-dotted-lines"
            case .tocHeaderText: return "--toc-header-text"
            case .tocLevelIndentation: return "--toc-level-indentation"
            case .disableTocLinks: return "--disable-toc-links"
            case .tocTextSizeShrink: return "--toc-text-size-shrink"
            }
        }
        
        public var description: String {
            return key
        }
        
        var values: [String] {
            var result: [String] = [self.description]
            switch self {
            case let .paperSize(v): result.append(v.rawValue)
            case let .orientation(v): result.append(v.rawValue)
            case let .topMargin(v): result.append(String(describing: v).appending("mm"))
            case let .rightMargin(v): result.append(String(describing: v).appending("mm"))
            case let .bottomMargin(v): result.append(String(describing: v).appending("mm"))
            case let .leftMargin(v): result.append(String(describing: v).appending("mm"))
            case let .pageHeight(v): result.append(String(describing: v).appending("mm"))
            case let .pageWidth(v): result.append(String(describing: v).appending("mm"))
            case let .replace(name, value): result.append(name); result.append(value)
            case let .tocHeaderText(v): result.append(v)
            case let .tocLevelIndentation(v): result.append(v)
            case let .tocTextSizeShrink(v): result.append(String(describing: v))
            default: break
            }
            return result
        }
    }
}
