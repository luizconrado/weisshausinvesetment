import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import retiveCaseRecordTypeId from '@salesforce/apex/DigibankCaseFormController.getEVKONTOCaseRecordTypeId';
import createCase from '@salesforce/apex/DigibankCaseFormController.createNewEVKnotoCase';
import createAttachment from '@salesforce/apex/DigibankCaseFormController.attachFilesToCase';

export default class DigibankCaseForm extends LightningElement {
    showForm = true;
    loaded = false;

    //picklist
    typeOptions = [];
    phoneOsOptions = [];
    phoneOsVersionOptions = [];
    phoneOsVersionMasterOptions = [];
    appVersionOptions = [];
    //values
    email;
    subject;
    issueExperiencing;
    phoneModel;
    OccurrenceOfIssue;
    stepstoReproduce;
    expectedResult;
    actualResult;
    phoneOs;
    phoneVersion;
    appVersion;
    //support
    evKontoCaseRecordTypeId = '';
    contentVersionIds = [];
    newCaseId;

    @wire(retiveCaseRecordTypeId)
    wiredretiveCaseRecordTypeId({ error, data }) {
        if (error) {
            console.error(error)
        } else if (data) {

            this.evKontoCaseRecordTypeId = data;

        }
    }


    @wire(getPicklistValuesByRecordType, { objectApiName: 'Case', recordTypeId: '$evKontoCaseRecordTypeId' })
    picklistInfoData({ error, data }) {
        if (error) {
            let errorObj = JSON.parse(JSON.stringify(error));
            console.error(errorObj);
        }
        if (data) {




            let phoneOsOptionsDetails = data.picklistFieldValues.Phone_OS__c;
            this.phoneOsOptions = phoneOsOptionsDetails.values.map(v => {
                return { label: v.label, value: v.value }
            });

            this.phoneOsVersionMasterOptions = data.picklistFieldValues.Phone_Operating_System_Version__c;

            let appVersionOptionsDetials = data.picklistFieldValues.App_Version__c;
            this.appVersionOptions = appVersionOptionsDetials.values.map(v => {
                return { label: v.label, value: v.value }
            });

        }
    }

    applyStyle() {
        const style = document.createElement('style');
        style.innerText = `
        .inputDesign .slds-input{
            height:48px;
            border-radius: 0px;
          
        }
        .inputDesign .slds-textarea{
            border-radius: 0px;
            height:86px;
        }
        .dateTimeInput .slds-form-element{
            width:100%
        }`;
        //applying styles dynmicaly to shadow dom elements
        let inputs = this.template.querySelectorAll('div.inputDesign');
        for (let div of inputs) {
            div.appendChild(style);
        }

    }
    rendered = false;
    renderedCallback() {
        if (this.rendered) return;
        this.applyStyle();
        let d = new Date();
        this.OccurrenceOfIssue = d.toISOString();

        this.rendered = true;
    }




    //handlers
    handlePhoneOsChange(event) {
        let value = event.target.value;
        this.phoneOs = value;

        let allDependendOptions = this.phoneOsVersionMasterOptions;

        let validArrayNumber = allDependendOptions.controllerValues[value]


        this.phoneOsVersionOptions = allDependendOptions.values.filter(v => {
            if (v.validFor[0] === validArrayNumber) {
                return { label: v.label, value: v.value }
            }
        })

    }

    handleValueChange(event) {
        let value = event.target.value;
        let field = event.target.name;
        this[field] = value;
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        this.contentVersionIds = uploadedFiles.map(f => f.contentVersionId)

        console.log("No. of files uploaded : ", this.contentVersionIds, uploadedFiles);
    }
    //validator
    checkFieldValidity() {
        let elements = this.template.querySelectorAll('lightning-input,lightning-combobox,lightning-textarea');
        return [...elements]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();

                return validSoFar && inputCmp.checkValidity();
            }, true);
    }

    //operations
    handleSave() {
        if (this.checkFieldValidity()) {

            let caseObject = {};
            caseObject.RecordTypeId = this.evKontoCaseRecordTypeId;
            caseObject.Origin = 'Web';
            caseObject.SuppliedEmail = this.email;
            caseObject.Subject = this.subject;
            caseObject.Description = `
            What issue are you Experiencing?
            ${this.issueExperiencing}
            
            Steps to Reproduce
            ${this.stepstoReproduce}
            `;
            caseObject.Type = 'Bug';
            caseObject.Phone_Model__c = this.phoneModel
            caseObject.Occurrence_Of_Issue__c = this.OccurrenceOfIssue;
            caseObject.Expected_Result__c = this.expectedResult;
            caseObject.Actual_Result__c = this.actualResult;
            caseObject.Phone_OS__c = this.phoneOs;
            caseObject.Phone_Model__c = this.phoneModel;
            caseObject.Phone_Operating_System_Version__c = this.phoneVersion;
            caseObject.App_Version__c = this.appVersion;


            this.loaded = true;
            createCase({
                newCase: caseObject
            }).then(result => {
                this.newCaseId = result;
                console.log('case id', result)
                if (this.contentVersionIds.length > 0) {
                    this._attachFilesToCase();
                }
                else {
                    this.loaded = false;
                    this.showForm = false;
                }
            }).catch(error => {
                this.loaded = false;
                console.error('newCase', error);
                let errorMsg = error.body.message;
                this.showToast('Error', errorMsg, 'error');
            });

        }
        else {
            console.log('fail')
        }
    }

    _attachFilesToCase() {
        createAttachment({
            caseId: this.newCaseId,
            contentVersionIds: this.contentVersionIds
        }).then(result => {
            this.loaded = false;
            this.showForm = false;
        }).catch(error => {
            this.loaded = false;
            console.error('createAttachment', error);
            let errorMsg = error.body.message;
            this.showToast('Error', errorMsg, 'error');

        });
    }
    //helper
    showToast(theTitle, theMessage, theVariant) {
        const event = new ShowToastEvent({
            title: theTitle,
            message: theMessage,
            variant: theVariant,
            messageTemplate: "{0}",
            messageTemplateData: [theMessage]
        });
        this.dispatchEvent(event);
    }
}