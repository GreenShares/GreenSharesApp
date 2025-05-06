import Foundation
import SwiftUI

// Model for carbon offset projects
struct CarbonProject: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let pricePerTon: Double
    let imageName: String
    let location: String
    let type: ProjectType
    
    enum ProjectType: String, CaseIterable {
        case reforestation = "Reforestation"
        case solarEnergy = "Solar Energy"
        case windEnergy = "Wind Energy"
        case oceanConservation = "Ocean Conservation"
    }
}

// Model for user's carbon credit holdings
struct CarbonHolding: Identifiable {
    let id = UUID()
    let projectId: UUID
    let projectName: String
    let tons: Double
    let purchaseDate: Date
    let purchasePrice: Double
    
    var totalCost: Double {
        return tons * purchasePrice
    }
}

// Model for user's portfolio
class UserPortfolio: ObservableObject {
    @Published var cash: Double = 1000.00
    @Published var totalCarbonOffset: Double = 0.75
    @Published var holdings: [CarbonHolding] = []
    @Published var retiredCredits: Double = 0.0
    
    // Demo projects
    let availableProjects: [CarbonProject] = [
        CarbonProject(name: "Amazon Rainforest Protection", description: "Preserves critical rainforest ecosystems and biodiversity", pricePerTon: 12.00, imageName: "Trees", location: "Brazil", type: .reforestation),
        CarbonProject(name: "Solar Farm Initiative", description: "Powers communities with clean solar energy", pricePerTon: 15.50, imageName: "PlantGrowing", location: "Nevada, USA", type: .solarEnergy),
        CarbonProject(name: "Wind Energy Development", description: "Offshore wind turbines generating clean electricity", pricePerTon: 11.25, imageName: "MoneyPlant", location: "Scotland, UK", type: .windEnergy)
    ]
    
    // Demo impact feed
    let impactFeed: [ImpactEvent] = [
        ImpactEvent(companyName: "Microsoft", logoName: "microsoft-logo", amount: 10000, date: Date()),
        ImpactEvent(companyName: "Apple", logoName: "apple-logo", amount: 8500, date: Date().addingTimeInterval(-86400 * 3)),
        ImpactEvent(companyName: "Amazon", logoName: "amazon-logo", amount: 12000, date: Date().addingTimeInterval(-86400 * 7))
    ]
    
    // Buy carbon credits
    func buyCredits(from project: CarbonProject, tons: Double) -> Bool {
        let cost = project.pricePerTon * tons
        
        if cost <= cash {
            cash -= cost
            totalCarbonOffset += tons
            
            // Add to holdings or update existing
            if let index = holdings.firstIndex(where: { $0.projectId == project.id }) {
                let existing = holdings[index]
                let updatedHolding = CarbonHolding(
                    projectId: project.id,
                    projectName: project.name,
                    tons: existing.tons + tons,
                    purchaseDate: Date(),
                    purchasePrice: (existing.purchasePrice * existing.tons + project.pricePerTon * tons) / (existing.tons + tons)
                )
                holdings[index] = updatedHolding
            } else {
                holdings.append(
                    CarbonHolding(
                        projectId: project.id,
                        projectName: project.name,
                        tons: tons,
                        purchaseDate: Date(),
                        purchasePrice: project.pricePerTon
                    )
                )
            }
            return true
        }
        return false
    }
    
    // Sell carbon credits
    func sellCredits(from holding: CarbonHolding, tons: Double) -> Bool {
        if let index = holdings.firstIndex(where: { $0.id == holding.id }), tons <= holding.tons {
            let salePrice = holding.purchasePrice * 1.05 // 5% markup for demonstration
            cash += tons * salePrice
            totalCarbonOffset -= tons
            
            // Update holdings
            if tons < holding.tons {
                holdings[index] = CarbonHolding(
                    projectId: holding.projectId,
                    projectName: holding.projectName,
                    tons: holding.tons - tons,
                    purchaseDate: holding.purchaseDate,
                    purchasePrice: holding.purchasePrice
                )
            } else {
                holdings.remove(at: index)
            }
            return true
        }
        return false
    }
    
    // Retire carbon credits
    func retireCredits(tons: Double) -> Bool {
        if tons <= totalCarbonOffset {
            // Simplified logic - in a real app, you'd choose which specific credits to retire
            var remaining = tons
            var holdingsToUpdate: [(index: Int, newTons: Double)] = []
            
            // Find holdings to retire from
            for (index, holding) in holdings.enumerated() {
                if remaining <= 0 { break }
                
                let tonsToRetire = min(holding.tons, remaining)
                remaining -= tonsToRetire
                
                let newTons = holding.tons - tonsToRetire
                if newTons > 0 {
                    holdingsToUpdate.append((index, newTons))
                }
            }
            
            // Update holdings in reverse order to prevent index issues during removal
            var indicesToRemove: [Int] = []
            for (index, holding) in holdings.enumerated() {
                if let updateInfo = holdingsToUpdate.first(where: { $0.index == index }) {
                    holdings[index] = CarbonHolding(
                        projectId: holding.projectId,
                        projectName: holding.projectName,
                        tons: updateInfo.newTons,
                        purchaseDate: holding.purchaseDate,
                        purchasePrice: holding.purchasePrice
                    )
                } else if holding.tons <= remaining {
                    indicesToRemove.append(index)
                }
            }
            
            // Remove empty holdings
            for index in indicesToRemove.sorted(by: >) {
                holdings.remove(at: index)
            }
            
            totalCarbonOffset -= tons
            retiredCredits += tons
            return true
        }
        return false
    }
}

// Model for rewards tier system
enum RewardsTier: String, CaseIterable {
    case seedling = "Seedling"
    case sapling = "Sapling"
    case tree = "Tree"
    case forest = "Forest"
    
    var requiredTons: Double {
        switch self {
        case .seedling: return 0
        case .sapling: return 5
        case .tree: return 15
        case .forest: return 50
        }
    }
    
    var discountPercentage: Int {
        switch self {
        case .seedling: return 5
        case .sapling: return 10
        case .tree: return 15
        case .forest: return 20
        }
    }
    
    static func getCurrentTier(for retiredTons: Double) -> RewardsTier {
        let tiers = RewardsTier.allCases
        for i in (0..<tiers.count).reversed() {
            if retiredTons >= tiers[i].requiredTons {
                return tiers[i]
            }
        }
        return .seedling
    }
    
    static func getNextTier(for currentTier: RewardsTier) -> RewardsTier? {
        let tiers = RewardsTier.allCases
        if let currentIndex = tiers.firstIndex(of: currentTier),
           currentIndex < tiers.count - 1 {
            return tiers[currentIndex + 1]
        }
        return nil
    }
}

// Model for reward coupons
struct RewardCoupon: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let discountPercentage: Int
    let imageName: String
    let expiryDate: Date
}

// Model for corporate impact events
struct ImpactEvent: Identifiable {
    let id = UUID()
    let companyName: String
    let logoName: String
    let amount: Double
    let date: Date
    
    var carsEquivalent: Int {
        // Simplified conversion: 1 ton of carbon = 0.21 cars off the road for a year
        return Int(amount * 0.21)
    }
}