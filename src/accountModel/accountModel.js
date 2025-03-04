import { LightningElement, api, track } from 'lwc';

export default class AccountModel extends LightningElement {

    @track accountName = '';
    @track industry = '';

    handleChanges(event){

        const field = event.target.dataset.id;
        if(field == 'accountName'){

            this.accountName = event.target.value;
        }
        else if(field == 'industry'){

            this.industry = event.target.value;
        }
    }

    handleSave(){

        createAccount({name: this.accountName, industry: this.industry})
        .then(result=>{

            this.dispatchEvent(new CustomEvent('accountCreated',{detail: result}));
        })

        .catch((error) => {
            console.error(error);
        });
    }

}