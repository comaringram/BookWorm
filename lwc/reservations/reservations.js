import { LightningElement } from 'lwc';
import book from '@salesforce/apex/ReservationsController.book';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SimpleReservation extends LightningElement {
    fullName = '';
    dateTimeValue = ''; // lightning-input datetime returns an ISO-like string
    isLoading = false;
    error = null;

    handleName(e) {
        this.fullName = e.target.value;
    }

    handleDateTime(e) {
        this.dateTimeValue = e.target.value;
    }

    handleClear() {
        this.fullName = '';
        this.dateTimeValue = '';
        this.error = null;
    }

    async handleBook() {
        this.error = null;

        const name = (this.fullName || '').trim();
        if (!name) {
            this.error = 'Name is required.';
            return;
        }
        if (!this.dateTimeValue) {
            this.error = 'Date/Time is required.';
            return;
        }

        this.isLoading = true;
        try {
            
            const resp = await book({
                fullName: name,
                startDateTime: this.dateTimeValue
            });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Booked',
                    message: `Reservation created: ${resp.reservationId}`,
                    variant: 'success'
                })
            );

            this.handleClear();
        } catch (e) {
            this.error = e?.body?.message || e?.message || 'Unknown error.';
        } finally {
            this.isLoading = false;
        }
    }
}
