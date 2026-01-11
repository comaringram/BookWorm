public with sharing class BookSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Books__c> searchBooks(String title, String author, String isbn) {
        title  = String.isBlank(title)  ? null : title.trim();
        author = String.isBlank(author) ? null : author.trim();
        isbn   = String.isBlank(isbn)   ? null : isbn.trim();

        if (title == null && author == null && isbn == null) {
            String soql = 'SELECT Id, Name, Author__c, ISBN__c, CreatedDate, Current_Invetory__c ' +
            'FROM Books__c ';
            return database.query(soql);
        }

        
        List<String> whereParts = new List<String>();

        if (title != null) {
            whereParts.add('Name LIKE \'%' + String.escapeSingleQuotes(title) + '%\'');
        }
        if (author != null) {
            whereParts.add('Author__c LIKE \'%' + String.escapeSingleQuotes(author) + '%\'');
        }
        if (isbn != null) {
            // Often ISBN is searched as exact match; change to LIKE if you prefer
            whereParts.add('ISBN__c = \'' + String.escapeSingleQuotes(isbn) + '\'');
        }

        String soql =
            'SELECT Id, Name, Author__c, ISBN__c, CreatedDate, Current_Invetory__c ' +
            'FROM Books__c ' +
            'WHERE ' + String.join(whereParts, ' AND ') + ' ' +
            'ORDER BY LastModifiedDate DESC ' +
            'LIMIT 200';

        return Database.query(soql);
    }
}
