import { LightningElement, api, track} from 'lwc';
//import getAccounts from '@salesforce/apex/LWC_AccountController.getAccounts';

export default class AccountTable extends LightningElement {

    @track accounts = [];
    @track isAccountModelOpen = false;
    @track isContactModelOpen = false;
    @track newlyCreatedAccountId;

    columns = [
        {label: 'Account Name', fieldName: 'Name'},
        {label: 'Industry', fieldName: 'Industry'},
        {
            type: 'button',
            typeAttributes: {label: 'Create Contact', name: 'create_contact', variant: 'brand'}
        }
    ];
}