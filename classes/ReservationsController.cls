public with sharing class ReservationsController {

    public class BookingResponse {
        @AuraEnabled public Id contactId;
        @AuraEnabled public Id reservationId;
    }

    @AuraEnabled
    public static BookingResponse book(String fullName, Datetime startDateTime) {
        fullName = String.isBlank(fullName) ? null : fullName.trim();

        if (fullName == null) {
            throw new AuraHandledException('Name is required.');
        }
        if (startDateTime == null) {
            throw new AuraHandledException('Date/Time is required.');
        }
        if (startDateTime < System.now()) {
            throw new AuraHandledException('Reservation must be future date and time');
        }

        List<String> parts = fullName.split('\\s+');
        String firstName;
        String lastName;

        if (parts.size() == 1) {
            lastName = parts[0];
        } else {
            lastName = parts[parts.size() - 1];
            parts.remove(parts.size() - 1);
            firstName = String.join(parts, ' ');
        }

        Contact c = new Contact(
            FirstName = firstName,
            LastName  = lastName
        );
        insert c;

        Reservation__c r = new Reservation__c(
            Contact__c = c.Id,
            Reservation_Time__c   = startDateTime
        );
        insert r;

        BookingResponse resp = new BookingResponse();
        resp.contactId = c.Id;
        resp.reservationId = r.Id;
        return resp;
    }
}
