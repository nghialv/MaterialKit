//
//  MKColor.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

extension UIColor {

    convenience public init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    public struct MKColor {

        public struct Red {
            public static let P50 = UIColor(hex: 0xFFEBEE)
            public static let P100 = UIColor(hex: 0xFFCDD2)
            public static let P200 = UIColor(hex: 0xEF9A9A)
            public static let P300 = UIColor(hex: 0xE57373)
            public static let P400 = UIColor(hex: 0xEF5350)
            public static let P500 = UIColor(hex: 0xF44336)
            public static let P600 = UIColor(hex: 0xE53935)
            public static let P700 = UIColor(hex: 0xD32F2F)
            public static let P800 = UIColor(hex: 0xC62828)
            public static let P900 = UIColor(hex: 0xB71C1C)
            public static let A100 = UIColor(hex: 0xFF8A80)
            public static let A200 = UIColor(hex: 0xFF5252)
            public static let A400 = UIColor(hex: 0xFF1744)
            public static let A700 = UIColor(hex: 0xD50000)
        }

        public struct Pink {
            public static let P50 = UIColor(hex: 0xFCE4EC)
            public static let P100 = UIColor(hex: 0xF8BBD0)
            public static let P200 = UIColor(hex: 0xF48FB1)
            public static let P300 = UIColor(hex: 0xF06292)
            public static let P400 = UIColor(hex: 0xEC407A)
            public static let P500 = UIColor(hex: 0xE91E63)
            public static let P600 = UIColor(hex: 0xD81B60)
            public static let P700 = UIColor(hex: 0xC2185B)
            public static let P800 = UIColor(hex: 0xAD1457)
            public static let P900 = UIColor(hex: 0x880E4F)
            public static let A100 = UIColor(hex: 0xFF80AB)
            public static let A200 = UIColor(hex: 0xFF4081)
            public static let A400 = UIColor(hex: 0xF50057)
            public static let A700 = UIColor(hex: 0xC51162)
        }

        public struct Purple {
            public static let P50 = UIColor(hex: 0xF3E5F5)
            public static let P100 = UIColor(hex: 0xE1BEE7)
            public static let P200 = UIColor(hex: 0xCE93D8)
            public static let P300 = UIColor(hex: 0xBA68C8)
            public static let P400 = UIColor(hex: 0xAB47BC)
            public static let P500 = UIColor(hex: 0x9C27B0)
            public static let P600 = UIColor(hex: 0x8E24AA)
            public static let P700 = UIColor(hex: 0x7B1FA2)
            public static let P800 = UIColor(hex: 0x6A1B9A)
            public static let P900 = UIColor(hex: 0x4A148C)
            public static let A100 = UIColor(hex: 0xEA80FC)
            public static let A200 = UIColor(hex: 0xE040FB)
            public static let A400 = UIColor(hex: 0xD500F9)
            public static let A700 = UIColor(hex: 0xAA00FF)
        }

        public struct DeepPurple {
            public static let P50 = UIColor(hex: 0xEDE7F6)
            public static let P100 = UIColor(hex: 0xD1C4E9)
            public static let P200 = UIColor(hex: 0xB39DDB)
            public static let P300 = UIColor(hex: 0x9575CD)
            public static let P400 = UIColor(hex: 0x7E57C2)
            public static let P500 = UIColor(hex: 0x673AB7)
            public static let P600 = UIColor(hex: 0x5E35B1)
            public static let P700 = UIColor(hex: 0x512DA8)
            public static let P800 = UIColor(hex: 0x4527A0)
            public static let P900 = UIColor(hex: 0x311B92)
            public static let A100 = UIColor(hex: 0xB388FF)
            public static let A200 = UIColor(hex: 0x7C4DFF)
            public static let A400 = UIColor(hex: 0x651FFF)
            public static let A700 = UIColor(hex: 0x6200EA)
        }

        public struct Indigo {
            public static let P50 = UIColor(hex: 0xE8EAF6)
            public static let P100 = UIColor(hex: 0xC5CAE9)
            public static let P200 = UIColor(hex: 0x9FA8DA)
            public static let P300 = UIColor(hex: 0x7986CB)
            public static let P400 = UIColor(hex: 0x5C6BC0)
            public static let P500 = UIColor(hex: 0x3F51B5)
            public static let P600 = UIColor(hex: 0x3949AB)
            public static let P700 = UIColor(hex: 0x303F9F)
            public static let P800 = UIColor(hex: 0x283593)
            public static let P900 = UIColor(hex: 0x1A237E)
            public static let A100 = UIColor(hex: 0x8C9EFF)
            public static let A200 = UIColor(hex: 0x536DFE)
            public static let A400 = UIColor(hex: 0x3D5AFE)
            public static let A700 = UIColor(hex: 0x304FFE)
        }

        public struct Blue {
            public static let P50 = UIColor(hex: 0xE3F2FD)
            public static let P100 = UIColor(hex: 0xBBDEFB)
            public static let P200 = UIColor(hex: 0x90CAF9)
            public static let P300 = UIColor(hex: 0x64B5F6)
            public static let P400 = UIColor(hex: 0x42A5F5)
            public static let P500 = UIColor(hex: 0x2196F3)
            public static let P600 = UIColor(hex: 0x1E88E5)
            public static let P700 = UIColor(hex: 0x1976D2)
            public static let P800 = UIColor(hex: 0x1565C0)
            public static let P900 = UIColor(hex: 0x0D47A1)
            public static let A100 = UIColor(hex: 0x82B1FF)
            public static let A200 = UIColor(hex: 0x448AFF)
            public static let A400 = UIColor(hex: 0x2979FF)
            public static let A700 = UIColor(hex: 0x2962FF)
        }

        public struct LightBlue {
            public static let P50 = UIColor(hex: 0xE1F5FE)
            public static let P100 = UIColor(hex: 0xB3E5FC)
            public static let P200 = UIColor(hex: 0x81D4FA)
            public static let P300 = UIColor(hex: 0x4FC3F7)
            public static let P400 = UIColor(hex: 0x29B6F6)
            public static let P500 = UIColor(hex: 0x03A9F4)
            public static let P600 = UIColor(hex: 0x039BE5)
            public static let P700 = UIColor(hex: 0x0288D1)
            public static let P800 = UIColor(hex: 0x0277BD)
            public static let P900 = UIColor(hex: 0x01579B)
            public static let A100 = UIColor(hex: 0x80D8FF)
            public static let A200 = UIColor(hex: 0x40C4FF)
            public static let A400 = UIColor(hex: 0x00B0FF)
            public static let A700 = UIColor(hex: 0x0091EA)
        }

        public struct Cyan {
            public static let P50 = UIColor(hex: 0xE0F7FA)
            public static let P100 = UIColor(hex: 0xB2EBF2)
            public static let P200 = UIColor(hex: 0x80DEEA)
            public static let P300 = UIColor(hex: 0x4DD0E1)
            public static let P400 = UIColor(hex: 0x26C6DA)
            public static let P500 = UIColor(hex: 0x00BCD4)
            public static let P600 = UIColor(hex: 0x00ACC1)
            public static let P700 = UIColor(hex: 0x0097A7)
            public static let P800 = UIColor(hex: 0x00838F)
            public static let P900 = UIColor(hex: 0x006064)
            public static let A100 = UIColor(hex: 0x84FFFF)
            public static let A200 = UIColor(hex: 0x18FFFF)
            public static let A400 = UIColor(hex: 0x00E5FF)
            public static let A700 = UIColor(hex: 0x00B8D4)
        }

        public struct Teal {
            public static let P50 = UIColor(hex: 0xE0F2F1)
            public static let P100 = UIColor(hex: 0xB2DFDB)
            public static let P200 = UIColor(hex: 0x80CBC4)
            public static let P300 = UIColor(hex: 0x4DB6AC)
            public static let P400 = UIColor(hex: 0x26A69A)
            public static let P500 = UIColor(hex: 0x009688)
            public static let P600 = UIColor(hex: 0x00897B)
            public static let P700 = UIColor(hex: 0x00796B)
            public static let P800 = UIColor(hex: 0x00695C)
            public static let P900 = UIColor(hex: 0x004D40)
            public static let A100 = UIColor(hex: 0xA7FFEB)
            public static let A200 = UIColor(hex: 0x64FFDA)
            public static let A400 = UIColor(hex: 0x1DE9B6)
            public static let A700 = UIColor(hex: 0x00BFA5)
        }

        public struct Green {
            public static let P50 = UIColor(hex: 0xE8F5E9)
            public static let P100 = UIColor(hex: 0xC8E6C9)
            public static let P200 = UIColor(hex: 0xA5D6A7)
            public static let P300 = UIColor(hex: 0x81C784)
            public static let P400 = UIColor(hex: 0x66BB6A)
            public static let P500 = UIColor(hex: 0x4CAF50)
            public static let P600 = UIColor(hex: 0x43A047)
            public static let P700 = UIColor(hex: 0x388E3C)
            public static let P800 = UIColor(hex: 0x2E7D32)
            public static let P900 = UIColor(hex: 0x1B5E20)
            public static let A100 = UIColor(hex: 0xB9F6CA)
            public static let A200 = UIColor(hex: 0x69F0AE)
            public static let A400 = UIColor(hex: 0x00E676)
            public static let A700 = UIColor(hex: 0x00C853)
        }

        public struct LightGreen {
            public static let P50 = UIColor(hex: 0xF1F8E9)
            public static let P100 = UIColor(hex: 0xDCEDC8)
            public static let P200 = UIColor(hex: 0xC5E1A5)
            public static let P300 = UIColor(hex: 0xAED581)
            public static let P400 = UIColor(hex: 0x9CCC65)
            public static let P500 = UIColor(hex: 0x8BC34A)
            public static let P600 = UIColor(hex: 0x7CB342)
            public static let P700 = UIColor(hex: 0x689F38)
            public static let P800 = UIColor(hex: 0x558B2F)
            public static let P900 = UIColor(hex: 0x33691E)
            public static let A100 = UIColor(hex: 0xCCFF90)
            public static let A200 = UIColor(hex: 0xB2FF59)
            public static let A400 = UIColor(hex: 0x76FF03)
            public static let A700 = UIColor(hex: 0x64DD17)
        }

        public struct Lime {
            public static let P50 = UIColor(hex: 0xF9FBE7)
            public static let P100 = UIColor(hex: 0xF0F4C3)
            public static let P200 = UIColor(hex: 0xE6EE9C)
            public static let P300 = UIColor(hex: 0xDCE775)
            public static let P400 = UIColor(hex: 0xD4E157)
            public static let P500 = UIColor(hex: 0xCDDC39)
            public static let P600 = UIColor(hex: 0xC0CA33)
            public static let P700 = UIColor(hex: 0xAFB42B)
            public static let P800 = UIColor(hex: 0x9E9D24)
            public static let P900 = UIColor(hex: 0x827717)
            public static let A100 = UIColor(hex: 0xF4FF81)
            public static let A200 = UIColor(hex: 0xEEFF41)
            public static let A400 = UIColor(hex: 0xC6FF00)
            public static let A700 = UIColor(hex: 0xAEEA00)
        }

        public struct Yellow {
            public static let P50 = UIColor(hex: 0xFFFDE7)
            public static let P100 = UIColor(hex: 0xFFF9C4)
            public static let P200 = UIColor(hex: 0xFFF59D)
            public static let P300 = UIColor(hex: 0xFFF176)
            public static let P400 = UIColor(hex: 0xFFEE58)
            public static let P500 = UIColor(hex: 0xFFEB3B)
            public static let P600 = UIColor(hex: 0xFDD835)
            public static let P700 = UIColor(hex: 0xFBC02D)
            public static let P800 = UIColor(hex: 0xF9A825)
            public static let P900 = UIColor(hex: 0xF57F17)
            public static let A100 = UIColor(hex: 0xFFFF8D)
            public static let A200 = UIColor(hex: 0xFFFF00)
            public static let A400 = UIColor(hex: 0xFFEA00)
            public static let A700 = UIColor(hex: 0xFFD600)
        }

        public struct Amber {
            public static let P50 = UIColor(hex: 0xFFF8E1)
            public static let P100 = UIColor(hex: 0xFFECB3)
            public static let P200 = UIColor(hex: 0xFFE082)
            public static let P300 = UIColor(hex: 0xFFD54F)
            public static let P400 = UIColor(hex: 0xFFCA28)
            public static let P500 = UIColor(hex: 0xFFC107)
            public static let P600 = UIColor(hex: 0xFFB300)
            public static let P700 = UIColor(hex: 0xFFA000)
            public static let P800 = UIColor(hex: 0xFF8F00)
            public static let P900 = UIColor(hex: 0xFF6F00)
            public static let A100 = UIColor(hex: 0xFFE57F)
            public static let A200 = UIColor(hex: 0xFFD740)
            public static let A400 = UIColor(hex: 0xFFC400)
            public static let A700 = UIColor(hex: 0xFFAB00)
        }

        public struct Orange {
            public static let P50 = UIColor(hex: 0xFFF3E0)
            public static let P100 = UIColor(hex: 0xFFE0B2)
            public static let P200 = UIColor(hex: 0xFFCC80)
            public static let P300 = UIColor(hex: 0xFFB74D)
            public static let P400 = UIColor(hex: 0xFFA726)
            public static let P500 = UIColor(hex: 0xFF9800)
            public static let P600 = UIColor(hex: 0xFB8C00)
            public static let P700 = UIColor(hex: 0xF57C00)
            public static let P800 = UIColor(hex: 0xEF6C00)
            public static let P900 = UIColor(hex: 0xE65100)
            public static let A100 = UIColor(hex: 0xFFD180)
            public static let A200 = UIColor(hex: 0xFFAB40)
            public static let A400 = UIColor(hex: 0xFF9100)
            public static let A700 = UIColor(hex: 0xFF6D00)
        }

        public struct DeepOrange {
            public static let P50 = UIColor(hex: 0xFBE9E7)
            public static let P100 = UIColor(hex: 0xFFCCBC)
            public static let P200 = UIColor(hex: 0xFFAB91)
            public static let P300 = UIColor(hex: 0xFF8A65)
            public static let P400 = UIColor(hex: 0xFF7043)
            public static let P500 = UIColor(hex: 0xFF5722)
            public static let P600 = UIColor(hex: 0xF4511E)
            public static let P700 = UIColor(hex: 0xE64A19)
            public static let P800 = UIColor(hex: 0xD84315)
            public static let P900 = UIColor(hex: 0xBF360C)
            public static let A100 = UIColor(hex: 0xFF9E80)
            public static let A200 = UIColor(hex: 0xFF6E40)
            public static let A400 = UIColor(hex: 0xFF3D00)
            public static let A700 = UIColor(hex: 0xDD2C00)
        }

        public struct Brown {
            public static let P50 = UIColor(hex: 0xEFEBE9)
            public static let P100 = UIColor(hex: 0xD7CCC8)
            public static let P200 = UIColor(hex: 0xBCAAA4)
            public static let P300 = UIColor(hex: 0xA1887F)
            public static let P400 = UIColor(hex: 0x8D6E63)
            public static let P500 = UIColor(hex: 0x795548)
            public static let P600 = UIColor(hex: 0x6D4C41)
            public static let P700 = UIColor(hex: 0x5D4037)
            public static let P800 = UIColor(hex: 0x4E342E)
            public static let P900 = UIColor(hex: 0x3E2723)
        }

        public struct Grey {
            public static let P50 = UIColor(hex: 0xFAFAFA)
            public static let P100 = UIColor(hex: 0xF5F5F5)
            public static let P200 = UIColor(hex: 0xEEEEEE)
            public static let P300 = UIColor(hex: 0xE0E0E0)
            public static let P400 = UIColor(hex: 0xBDBDBD)
            public static let P500 = UIColor(hex: 0x9E9E9E)
            public static let P600 = UIColor(hex: 0x757575)
            public static let P700 = UIColor(hex: 0x616161)
            public static let P800 = UIColor(hex: 0x424242)
            public static let P900 = UIColor(hex: 0x212121)
        }

        public struct BlueGrey {
            public static let P50 = UIColor(hex: 0xECEFF1)
            public static let P100 = UIColor(hex: 0xCFD8DC)
            public static let P200 = UIColor(hex: 0xB0BEC5)
            public static let P300 = UIColor(hex: 0x90A4AE)
            public static let P400 = UIColor(hex: 0x78909C)
            public static let P500 = UIColor(hex: 0x607D8B)
            public static let P600 = UIColor(hex: 0x546E7A)
            public static let P700 = UIColor(hex: 0x455A64)
            public static let P800 = UIColor(hex: 0x37474F)
            public static let P900 = UIColor(hex: 0x263238)
        }
    }
}
