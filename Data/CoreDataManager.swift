//
//  CoreDataManager.swift
//  LMC_Tracker
//
//  Created by Dean Wagstaff on 12/8/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    // MARK: - Fetch/Get Functions

    func getAllMembers() -> [MembersEntity]? {
        let fetchRequest: NSFetchRequest<MembersEntity> = MembersEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.name.rawValue, ascending: true)
                
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [MembersEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getMember(name: String) -> [MembersEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MembersEntity")

        fetchRequest.predicate = NSPredicate(format: "name = %@", name)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [MembersEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getAnnouncement(fyi: String) -> [AnnouncementsEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AnnouncementsEntity")

        fetchRequest.predicate = NSPredicate(format: "fyi = %@", fyi)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [AnnouncementsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }


    func getMember(uid: String) -> [MembersEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MembersEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [MembersEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getSpeakingAssignments(with predicate: NSPredicate?) -> [SpeakingAssignmentsEntity]? {
        let fetchRequest: NSFetchRequest<SpeakingAssignmentsEntity> = SpeakingAssignmentsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "weekOfYear", ascending: true)
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [SpeakingAssignmentsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getOrgMbrCallings(with predicate: NSPredicate?) -> [OrgMbrCallingEntity]? {
        let fetchRequest: NSFetchRequest<OrgMbrCallingEntity> = OrgMbrCallingEntity.fetchRequest()
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [OrgMbrCallingEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getCallings(with predicate: NSPredicate?) -> [CallingsEntity]? {
        let fetchRequest: NSFetchRequest<CallingsEntity> = CallingsEntity.fetchRequest()
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [CallingsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getAllOrganizations() -> [OrganizationsEntity]? {
        let fetchRequest: NSFetchRequest<OrganizationsEntity> = OrganizationsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                let distinctValues = results?.compactMap { $0 }
                
                return distinctValues as? [OrganizationsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getAllInterviews() -> [InterviewsEntity]? {
        let fetchRequest: NSFetchRequest<InterviewsEntity> = InterviewsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.category.rawValue, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                let distinctValues = results?.compactMap { $0 }
                
                return distinctValues as? [InterviewsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getStakes() -> [StakeEntity]? {
        let fetchRequest: NSFetchRequest<StakeEntity> = StakeEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "stakeUnitNumber", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                let distinctValues = results?.compactMap { $0 }
                
                return distinctValues as? [StakeEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getOrganization(uid: String) -> [OrganizationsEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrganizationsEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [OrganizationsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getStake(uid: String) -> [StakeEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StakeEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [StakeEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getInterviews(with predicate: NSPredicate?) -> [InterviewsEntity]? {
        let fetchRequest: NSFetchRequest<InterviewsEntity> = InterviewsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.scheduledInterviewDate.rawValue, ascending: true)
        
        if predicate != nil {
            fetchRequest.predicate = predicate //NSPredicate(format: "name = %@", name)
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [InterviewsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getInterview(uid: String) -> [InterviewsEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InterviewsEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [InterviewsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getNote(uid: String) -> [NotesEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [NotesEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getPrayers(with predicate: NSPredicate?) -> [PrayersEntity]? {
        let fetchRequest: NSFetchRequest<PrayersEntity> = PrayersEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.name.rawValue, ascending: true)
        
        if predicate != nil {
            fetchRequest.predicate = predicate //NSPredicate(format: "name = %@", name)
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [PrayersEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getPrayer(uid: String) -> [PrayersEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PrayersEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [PrayersEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getAnnouncement(uid: String) -> [AnnouncementsEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AnnouncementsEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [AnnouncementsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getOrdination(uid: String) -> [OrdinationsEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrdinationsEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)

        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [OrdinationsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getAnnouncements() -> [AnnouncementsEntity]? {
        let fetchRequest: NSFetchRequest<AnnouncementsEntity> = AnnouncementsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.fyi.rawValue, ascending: true)
                
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                return (results ?? nil) as? [AnnouncementsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    func getOrdinations(with predicate: NSPredicate?) -> [OrdinationsEntity]? {
        let fetchRequest: NSFetchRequest<OrdinationsEntity> = OrdinationsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if !(results?.isEmpty ?? false) {
                let distinctValues = results?.compactMap { $0 }
                
                return distinctValues as? [OrdinationsEntity]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        return nil
    }
    
    // MARK: - ADD Functions
    
    func addMember(member: Member, completion: @escaping (_ results: String ) -> Void) {
        let fetchRequest: NSFetchRequest<MembersEntity> = MembersEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.name.rawValue, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: DictionaryKeys.name.rawValue + " = %@", member.name)
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty ?? false) {
                let members = MembersEntity(context: container.viewContext)
                
                members.name = member.name
                members.uid = member.id
                members.welcomed = member.welcomed
                
                self.saveContext()
                
                completion("Coredata Success adding member")
            }
        } catch {
            completion("Coredata Error adding member : \(error.localizedDescription)")
        }
    }
    
    func addOrganization(organization: Organization, completion: @escaping (_ results: String ) -> Void) {
        let fetchRequest: NSFetchRequest<OrganizationsEntity> = OrganizationsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", organization.name)
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty ?? false) {
                let organizations = OrganizationsEntity(context: container.viewContext)
                
                organizations.name = organization.name
                organizations.uid = organization.id
                
                self.saveContext()
                
                completion("Coredata Success adding organization")
            }
        } catch {
            completion("Coredata Error adding organization : \(error.localizedDescription)")
        }
    }
    
    @MainActor func addStake(stake: Stake, completion: @escaping (_ results: String ) -> Void) {
        let fetchRequest: NSFetchRequest<StakeEntity> = StakeEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "stakeUnitNumber", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "stakeName = %@", stake.stakeName)
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty ?? false) {
                let stakeEntity = StakeEntity(context: container.viewContext)
                
                stakeEntity.stakeName = stake.stakeName
                stakeEntity.stakeUnitNumber = stake.stakeUnitNumber
                stakeEntity.units = DataManager.shared.convertArrayOfUnitsToDeliniatedString(units: stake.units)
                stakeEntity.uid = stake.id
                
                self.saveContext()
                
                completion("Coredata Success adding unit in stake")
            }
        } catch {
            completion("Coredata Error adding unit in stake : \(error.localizedDescription)")
        }
    }
    
    func addSpeakingAssignment(speakingAssignment: SpeakingAssignment) {
        let fetchRequest: NSFetchRequest<SpeakingAssignmentsEntity> = SpeakingAssignmentsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.name.rawValue, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "uid = %@", speakingAssignment.uid)
                
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty ?? false) {
                let speakingAssignments = SpeakingAssignmentsEntity(context: container.viewContext)

                speakingAssignments.uid = speakingAssignment.uid
                speakingAssignments.name = speakingAssignment.name
                speakingAssignments.topic = speakingAssignment.topic
                speakingAssignments.askToSpeakOnDate = speakingAssignment.askToSpeakOnDate
                speakingAssignments.weekOfYear = speakingAssignment.weekOfYear
                speakingAssignments.weekNumberInMonthForSunday = speakingAssignment.weekNumberInMonthForSunday
                
                self.saveContext()
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
    }

    func addOrgMbrCalling(orgMbrCalling: OrgMbrCalling, completion: @escaping (_ results: String ) -> Void) {
        let fetchRequest: NSFetchRequest<OrgMbrCallingEntity> = OrgMbrCallingEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "organizationName = %@ AND callingName = %@", orgMbrCalling.organizationName, orgMbrCalling.callingName)
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty ?? false) {
                let newMbrOrgCall = OrgMbrCallingEntity(context: container.viewContext)
                newMbrOrgCall.uid = orgMbrCalling.id
                newMbrOrgCall.memberName = orgMbrCalling.memberName
                newMbrOrgCall.approvedDate = orgMbrCalling.approvedDate
                newMbrOrgCall.calledDate = orgMbrCalling.calledDate
                newMbrOrgCall.callingName = orgMbrCalling.callingName
                newMbrOrgCall.organizationName = orgMbrCalling.organizationName
                newMbrOrgCall.recommendedDate = orgMbrCalling.recommendedDate
                newMbrOrgCall.setApartDate = orgMbrCalling.setApartDate
                newMbrOrgCall.sustainedDate = orgMbrCalling.sustainedDate
                newMbrOrgCall.releasedDate = orgMbrCalling.releasedDate
                newMbrOrgCall.memberToBeReleased = orgMbrCalling.memberToBeReleased
                newMbrOrgCall.ldrAssignToCall = orgMbrCalling.ldrAssignToCall
                newMbrOrgCall.ldrAssignToSetApart = orgMbrCalling.ldrAssignToSetApart
                newMbrOrgCall.callingPreviouslyFilledDate = orgMbrCalling.callingPreviouslyFilledDate
                newMbrOrgCall.callingDisplayIndex = orgMbrCalling.callingDisplayIndex
                newMbrOrgCall.callingAction = orgMbrCalling.callingAction
                newMbrOrgCall.recommendations = orgMbrCalling.recommendations
                
                self.saveContext()
                
                completion("Coredata Success adding orgMbrCalling")
            }
        } catch {
            completion("Coredata Error adding orgMbrCalling : \(error.localizedDescription)")
        }
    }
        
    func addInterview(interviewModel: Interview, id: String, completion: @escaping (_ results: String) -> Void) {
        let fetchRequest: NSFetchRequest<InterviewsEntity> = InterviewsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.category.rawValue, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty ?? false) {
                let interviews = InterviewsEntity(context: container.viewContext)
                
                interviews.scheduledInterviewDate = interviewModel.scheduledInterviewDate
                interviews.scheduledInterviewTime = interviewModel.scheduledInterviewTime
                interviews.uid = interviewModel.id
                interviews.details = interviewModel.details
                interviews.notes = interviewModel.notes
                interviews.ldrAssignToDoInterview = interviewModel.ldrAssignToDoInterview
                interviews.name = interviewModel.name
                interviews.status = interviewModel.status
                interviews.category = interviewModel.category
                interviews.ordination = interviewModel.ordination
                
                self.saveContext()
                print("core data success adding interview")
                completion("Coredata Success Adding Interview")
            }
        } catch {
            completion("Coredata Error Adding Interview : \(error)")
        }
        
    }
    
    func addNote(noteModel: Note) {
        let container = self.persistentContainer
        
        let notes = NotesEntity(context: container.viewContext)
        
        notes.uid = noteModel.id
        notes.content = noteModel.content
        notes.leader = noteModel.leader
        
        self.saveContext()
    }
    
    func addPrayer(prayer: Prayer, completion: @escaping (_ results: String) -> Void) {
        let fetchRequest: NSFetchRequest<PrayersEntity> = PrayersEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name = %@ AND date = %@", prayer.name, prayer.date)
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty) ?? false {
                let prayers = PrayersEntity(context: container.viewContext)
                prayers.uid = prayer.id
                prayers.name = prayer.name
                prayers.date = prayer.date
                
                self.saveContext()
            }
        } catch {
            print("Fetch for Prayer Failed: \(error)")
        }
    }
    
    func addAnnouncement(announcement: Announcement, completion: @escaping (_ results: String) -> Void) {
        let fetchRequest: NSFetchRequest<AnnouncementsEntity> = AnnouncementsEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "fyi = %@", announcement.fyi)
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty) ?? false {
                let announcements = AnnouncementsEntity(context: container.viewContext)
                announcements.uid = announcement.id
                announcements.fyi = announcement.fyi
                announcements.announced = announcement.announced
                
                self.saveContext()
            }
        } catch {
            print("Fetch for Announcement Failed: \(error)")
        }
    }
    
    func addOrdination(ordination: Ordination, completion: @escaping (_ results: String ) -> Void) {
        let fetchRequest: NSFetchRequest<OrdinationsEntity> = OrdinationsEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: DictionaryKeys.name.rawValue, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: DictionaryKeys.name.rawValue + " = %@", ordination.name)
        
        let container = self.persistentContainer
        
        do {
            let results = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if (results?.isEmpty ?? false) {
                let ordinations = OrdinationsEntity(context: container.viewContext)
                
                ordinations.name = ordination.name
                ordinations.uid = ordination.id
                ordinations.datePerformed = ordination.datePerformed
                ordinations.status = ordination.status
                ordinations.ordinationOffice = ordination.ordinationOffice
                
                self.saveContext()
                print("core dats success adding ordination")
                completion("Coredata Success adding ordination")
            }
        } catch {
            completion("Coredata Error adding ordination : \(error)")
        }
    }
        
    // MARK: - UPDATE Functions
    
    func updateMember(model: Member, completion: @escaping () -> Void) {
        let member = getMember(name: model.name)
        
        member?.first?.uid = model.uid
        member?.first?.name = model.name
        member?.first?.welcomed = model.welcomed
        
        saveContext()
        
        completion()
    }
    
    func updateAnnouncement(model: Announcement, completion: @escaping () -> Void) {
        let announcement = getAnnouncement(fyi: model.fyi)
        
        announcement?.first?.uid = model.uid
        announcement?.first?.fyi = model.fyi
        announcement?.first?.announced = model.announced
        
        saveContext()
        
        completion()
    }

    func updateCalling(model: OrgMbrCalling, completion: @escaping () -> Void) {
        let predicate = NSPredicate(format: "organizationName = %@ AND callingName = %@", model.organizationName, model.callingName)
        
        let orgCalling = getOrgMbrCallings(with: predicate)
        
        orgCalling?.first?.uid = model.uid
        orgCalling?.first?.approvedDate = model.approvedDate
        orgCalling?.first?.calledDate = model.calledDate
        orgCalling?.first?.callingName = model.callingName
        orgCalling?.first?.memberToBeReleased = model.memberToBeReleased
        orgCalling?.first?.organizationName = model.organizationName
        orgCalling?.first?.memberName = model.memberName
        orgCalling?.first?.recommendedDate = model.recommendedDate
        orgCalling?.first?.releasedDate = model.releasedDate
        orgCalling?.first?.setApartDate = model.setApartDate
        orgCalling?.first?.sustainedDate = model.sustainedDate
        orgCalling?.first?.ldrAssignToCall = model.ldrAssignToCall
        orgCalling?.first?.ldrAssignToSetApart = model.ldrAssignToSetApart
        orgCalling?.first?.callingPreviouslyFilledDate = model.callingPreviouslyFilledDate
        orgCalling?.first?.callingDisplayIndex = model.callingDisplayIndex
        orgCalling?.first?.callingAction = model.callingAction
        orgCalling?.first?.recommendations = model.recommendations
        
        saveContext()
        
        completion()
    }
    
    func updateInterview(model: Interview, completion: @escaping () -> Void) {
        let predicate = NSPredicate(format: "uid = %@", model.uid)
        
        let interview = getInterviews(with: predicate)
        
        interview?.first?.uid = model.uid
        interview?.first?.name = model.name
        interview?.first?.ldrAssignToDoInterview = model.ldrAssignToDoInterview
        interview?.first?.scheduledInterviewDate = model.scheduledInterviewDate
        interview?.first?.scheduledInterviewTime = model.scheduledInterviewTime
        interview?.first?.notes = model.notes
        interview?.first?.details = model.details
        interview?.first?.ordination = model.ordination
        interview?.first?.status = model.status
        interview?.first?.category = model.category
        
        saveContext()
        
        completion()
    }
    
    // MARK: - Delete Functions
    
    func deleteMember(uid: String, completion: @escaping () -> Void) {
        if let memberEntity = getMember(uid: uid)?.first {
            viewContext.delete(memberEntity)
            saveContext()
            
            completion()
        }
    }
    
    func deleteUnitInStake(uid: String, completion: @escaping () -> Void) {
        if let unitsInStakeEntity = getStake(uid: uid)?.first {
            viewContext.delete(unitsInStakeEntity)
            saveContext()
            
            completion()
        }
    }
     
    func deleteOrganization(uid: String, completion: @escaping () -> Void) {
        if let organizationEntity = getOrganization(uid: uid)?.first {
            viewContext.delete(organizationEntity)
            saveContext()
            
            completion()
        }
    }
    
    func deleteInterview(uid: String, completion: @escaping () -> Void) {
        if let interviewsEntity = getInterview(uid: uid)?.first {
            viewContext.delete(interviewsEntity)
            saveContext()
            
            completion()
        }
    }
    
    func deleteNote(uid: String, completion: @escaping () -> Void) {
        if let notesEntity = getNote(uid: uid)?.first {
            viewContext.delete(notesEntity)
            saveContext()
            
            completion()
        }
    }

    func deletePrayer(uid: String, completion: @escaping () -> Void) {
        if let prayersEntity = getPrayer(uid: uid)?.first {
            viewContext.delete(prayersEntity)
            saveContext()
            
            completion()
        }
    }

    func deleteAnnouncement(uid: String, completion: @escaping () -> Void) {
        if let announcementsEntity = getAnnouncement(uid: uid)?.first {
            viewContext.delete(announcementsEntity)
            saveContext()
            
            completion()
        }
    }

    func deleteOrdination(uid: String, completion: @escaping () -> Void) {
        if let ordinationsEntity = getOrdination(uid: uid)?.first {
            viewContext.delete(ordinationsEntity)
            saveContext()
            
            completion()
        }
    }

    // MARK: - Core Data stack
    
    lazy var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var cacheContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    lazy var updateContext: NSManagedObjectContext = {
        let _updateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _updateContext.parent = self.viewContext
        return _updateContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ThirdCounselorDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


