import { LightningElement, track } from 'lwc';
import searchBooks from '@salesforce/apex/BookSearchController.searchBooks';

const COLUMNS = [
    { label: 'Title', fieldName: 'Name', wrapText: true },
    { label: 'Author', fieldName: 'Author__c' },
    { label: 'ISBN', fieldName: 'ISBN__c' },
    { label: 'Current Inventory', fieldName: 'Current_Invetory__c' }
];

export default class BookSearch extends LightningElement {
    title = '';
    author = '';
    isbn = '';

    columns = COLUMNS;

    @track results = null;
    error = null;
    isLoading = false;

    handleTitle(e) { this.title = e.target.value; }
    handleAuthor(e) { this.author = e.target.value; }
    handleIsbn(e) { this.isbn = e.target.value; }

    async handleSearch() {
        this.error = null;
        this.results = null;
        this.isLoading = true;

        try {
            const data = await searchBooks({
                title: this.title,
                author: this.author,
                isbn: this.isbn
            });

            this.results = data;
            if (!data || data.length === 0) {
                this.error = 'No books found.';
            }
        } catch (e) {
            this.error = e?.body?.message || e?.message || 'Unknown error';
        } finally {
            this.isLoading = false;
        }
    }

    handleClear() {
        this.title = '';
        this.author = '';
        this.isbn = '';
        this.results = null;
        this.error = null;
    }
}
