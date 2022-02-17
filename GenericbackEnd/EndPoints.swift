//
//  EndPoints.swift
//  taxiapp
//
//  Created by Jagruti on 10/13/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
public protocol EndPointProtocol {
    var endpointString: String { get }
    var method: HttpMethod { get }
}
enum EndPoints: EndPointProtocol {
    var method: HttpMethod {
        switch self {
        case .setCustomerActualAddress, .addCustomeContactUsMessage,
                .login, .verifypin, .confirmUser, .updateCustomerInfoOnSplash, .ChangePassword, .modifyCustomerInfo, .CustomerAppBooking, .CancelBooking, .RegisterDeviceToken, .NoCarsAvailableBookingLocation, .Estimateprice, .Addfavorite:
            return HttpMethod.POST
        default:
            return HttpMethod.GET
        }
    }

    var endpointString: String {
        switch self {
        case .login:
            return baseUrl + EndPointString.Login.rawValue
        case .verifypin:
            return baseUrl + EndPointString.VerifyPin.rawValue
        case .confirmUser:
            return baseUrl + EndPointString.Confirm.rawValue
            
        case let .getCustomerOrganizationsList(userId, deviceId):
            return baseUrl + String(format: EndPointString.GetCustomerOrgnizationsList.rawValue, userId, deviceId)
        case let .getNearestVehicle(lat, long, vehicleType, userId, deviceId):
            return baseUrl + String(format: EndPointString.GetNearestVehicles.rawValue, lat, long, vehicleType, userId, deviceId)
        case .setCustomerActualAddress:
            return baseUrl + EndPointString.SetCustomerActualAddress.rawValue
        case let .getAllBookings(userId, deviceId):
            return baseUrl + String(format: EndPointString.GetAllBookings.rawValue, userId, deviceId)
        case let .reedemPromotionCode(userId, code, deviceId):
            return baseUrl + String(format: EndPointString.ReedemPromotionCode.rawValue, userId, code, deviceId)
        case let .getContactUsReasonsList(userId, deviceId, language):
            return baseUrl + String(format: EndPointString.GetContactUsReasonsList.rawValue, userId, deviceId, language)
        case .addCustomeContactUsMessage:
            return baseUrl + EndPointString.AddCustomeContactUsMessage.rawValue
        case .modifyCustomerInfo:
            return baseUrl + EndPointString.ModifyCustomerInfo.rawValue
        case let .generateCustomerNewPassword(phoneno, password, code, appCode):
            return baseUrl + String(format: EndPointString.GenerateCustomerNewPassword.rawValue, phoneno, password, code, appCode)
        case let .sendResetPasswordVerifyCode(mobileno, appCode):
            return baseUrl + String(format: EndPointString.SendResetPasswordVerifyCode.rawValue, mobileno, appCode)
        case let .createCustomerAccount(customerName, password, phoneno, code, companyCode, deviceModel, osVersion, applicationVersion, defaultLanguage, appCode):
            return baseUrl + String(format: EndPointString.CreateCustomerAccount.rawValue, customerName, password, phoneno, code, companyCode, deviceModel, osVersion, applicationVersion, defaultLanguage, appCode)
        case .updateCustomerInfoOnSplash:
            return baseUrl + EndPointString.UpdateCustomerInfoOnSplashResult.rawValue
        case .ChangePassword:
            return baseUrl + EndPointString.ChangePassword.rawValue
        case let .updateTripRating(userId, deviceID, bookingId, driverId, rating, message):
            return baseUrl + String(format: EndPointString.updateTripRating.rawValue, userId, deviceID, bookingId, driverId, rating, message)
        case .CustomerAppBooking:
            return baseUrl + String(format: EndPointString.CustomerAppBooking.rawValue)
        case let .ValidateAccepted(bookId):
            return baseUrl + String(format: EndPointString.ValidateAccepted.rawValue, bookId)
        case let .TrackMyCab(bookId, tokenId):
            return baseUrl + String(format: EndPointString.TrackMyCab.rawValue, bookId, tokenId)
        case .CancelBooking:
            return baseUrl + String(format: EndPointString.CancelBooking.rawValue)
        case .RegisterDeviceToken:
            return baseUrl + String(format: EndPointString.RegisterDeviceToken.rawValue)

        case let .GetServicesList(userid, long, lat, appCode, lang, token):
            return baseUrl + String(format: EndPointString.GetServicesList.rawValue, userid, long, lat, appCode, lang, token)
        case let .GetAppAddress(district, Latitude, Longitude, Filter, Options, Token):
            return baseUrl + String(format: EndPointString.GetAppAddress.rawValue, district, Latitude, Longitude, Filter, Options, Token)
        case let .InsertLocationAddress(Latitude, Longitude, Building, Street, Neigbourhood, NickName, Token):
            return baseUrl + String(format: EndPointString.InsertLocationAddress.rawValue, Latitude, Longitude, Building, Street, Neigbourhood, NickName, Token)
        case .NoCarsAvailableBookingLocation:
            return baseUrl + String(format: EndPointString.NoCarsAvailableBookingLocation.rawValue)
        //case let .GetBookingInfo(userID, bookingID, vehicleID, enterpriseCustomerID, token):
            //return baseUrl + String(format: EndPointString.GetBookingInfo.rawValue, userID, bookingID, vehicleID, enterpriseCustomerID, token)
        case .Estimateprice:
            return baseUrl + EndPointString.Estimateprice.rawValue
        case .Addfavorite:
             return baseUrl + EndPointString.Addfavorite.rawValue
        case let .Removefavorite(userId, token, oid):
             return baseUrl + String(format: EndPointString.Removefavorite.rawValue, userId, token, oid)
        case let .Getfavorites(userId, token):
             return baseUrl +  String(format: EndPointString.Getfavorites.rawValue, userId, token)
        //case let .adGet(userId, lat, long, token):
             //return baseUrl +  String(format: EndPointString.adGet.rawValue, userId, long, lat, token)
        case let .adview(userId, adId ,lat, long, token):
            return baseUrl +  String(format: EndPointString.adview.rawValue, userId, adId, long, lat, token)
        case let .adremove(userId, adId ,lat, long, token):
            return baseUrl +  String(format: EndPointString.adremove.rawValue, userId, adId, long, lat, token)
        case let .convertPointsToCredit(userID, token):
            return baseUrl + String(format: EndPointString.convertPointsToCredit.rawValue, userID, token)
        case let .getPointConvertDtls(userID, token):
            return baseUrl + String(format: EndPointString.getPointConvertDtls.rawValue, userID, token)
        }
    }

    case login
    case verifypin
    case confirmUser
    
    case getCustomerOrganizationsList(String, String)
    case getNearestVehicle(String, String, String, String, String)
    case setCustomerActualAddress
    case getAllBookings(String, String)
    case reedemPromotionCode(String, String, String)
    case getContactUsReasonsList(String,String, String)
    case addCustomeContactUsMessage
    case modifyCustomerInfo
    case generateCustomerNewPassword(String, String, String, String)
    case sendResetPasswordVerifyCode(String, String)
    case createCustomerAccount(String, String, String, String, String, String ,String, String, String, String)
    case updateCustomerInfoOnSplash
    case ChangePassword
    case updateTripRating(String, String, String, String, String, String)
    case CustomerAppBooking
    case ValidateAccepted(String)
    case TrackMyCab(String, String)
    case CancelBooking
    case RegisterDeviceToken
    case GetServicesList(String, String, String, String, String, String)
    case GetAppAddress(String, String, String, String, String, String)
    case InsertLocationAddress(String, String, String, String, String, String, String)
    case NoCarsAvailableBookingLocation
    //case GetBookingInfo(String, String, String, String, String)
    case Estimateprice
    case Addfavorite
    case Removefavorite(String, String, String)
    case Getfavorites(String, String)
    //case adGet(String, String, String, String)
    case adview(String, String, String, String, String)
    case adremove(String, String, String, String, String)
    case convertPointsToCredit(String, String)
    case getPointConvertDtls(String, String)

    enum EndPointString: String {
        case Login = "login"
        case VerifyPin = "verify"
        case Confirm = "confirm"
        
        case GetCustomerOrgnizationsList = "GetCustomerOrgnizationsList/%@/%@"
        case GetNearestVehicles = "getAvailableCars/%@/%@/%@/0/%@/%@"
        case SetCustomerActualAddress = "SetCustomerActualAddress"
        case GetAllBookings = "GetAllBookings/%@/All/0/%@"
        case ReedemPromotionCode = "ReedemPromotionCode/%@/%@/%@"
        case GetContactUsReasonsList = "GetContactUsReasonsList/%@/%@/%@/cu/null/null"
        case AddCustomeContactUsMessage = "AddCustomeContactUsMessage"
        case ModifyCustomerInfo = "ModifyCustomerInfo"
        case GenerateCustomerNewPassword = "GenerateCustomerNewPassword/%@/%@/%@/%@"
        case SendResetPasswordVerifyCode = "SendResetPasswordVerifyCode/%@/%@"
        case CreateCustomerAccount = "CreateCustomerAccount/%@/%@/%@/null/%@/%@/IOS/%@/%@/%@/%@/%@"
        case UpdateCustomerInfoOnSplashResult = "UpdateCustomerInfoOnSplash"
        case ChangePassword = "ChangePassword"
        case updateTripRating = "updateTripRating/%@/%@/%@/%@/%@/%@"
        case CustomerAppBooking = "CustomerAppBooking"
        case ValidateAccepted = "ValidateAccepted/%@"
        case TrackMyCab = "v2bookedCarInfo/%@/%@"
        case CancelBooking = "CustomerCancelBooking"
        
        case RegisterDeviceToken = "RegisterDeviceToken"
        case GetServicesList = "GetServiceList/%@/%@/%@/%@/%@/%@"
        case GetAppAddress = "GetAppAddress/%@/%@/%@/%@/%@/%@"
        case InsertLocationAddress = "InsertLocationAddress/%@/%@/%@/%@/%@/%@/%@"
        case NoCarsAvailableBookingLocation = "NoCarsAvailableBookingLocation"
        //case GetBookingInfo = "GetBookingInfo/%@/%@/%@/%@/%@"
        case Estimateprice = "estimateprice"
        case Addfavorite = "v2addFavorite"
        case Removefavorite = "removefavorite/%@/%@/%@"
        case Getfavorites = "v2getfavorites/%@/%@"
        //case adGet = "v2adGet/%@/%@/%@/%@"
        case adview = "adview/%@/%@/%@/$@/%@"
        case adremove = "adremove/%@/%@/%@/%@/%@"
        case getPointConvertDtls = "getPointConvertDtls/%@/%@"
        case convertPointsToCredit = "ConvertPointsToCredit/%@/%@"
    }

}
