import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import retiveCaseRecordTypeId from '@salesforce/apex/DigibankCaseFormController.getEVKONTOCaseRecordTypeId';
import createCase from '@salesforce/apex/DigibankCaseFormController.createNewEVKnotoCase';
import createAttachment from '@salesforce/apex/DigibankCaseFormController.attachFilesToCase';

import DigibankCaseForm_Title from '@salesforce/label/c.DigibankCaseForm_Title';
import DigibankCaseForm_Thankyou from '@salesforce/label/c.DigibankCaseForm_Thankyou';
import DigibankCaseForm_EmailField from '@salesforce/label/c.DigibankCaseForm_EmailField';
import DigibankCaseForm_SubjectField from '@salesforce/label/c.DigibankCaseForm_SubjectField';
import DigibankCaseForm_IssueField from '@salesforce/label/c.DigibankCaseForm_IssueField';
import DigibankCaseForm_OccurenceField from '@salesforce/label/c.DigibankCaseForm_OccurenceField';
import DigibankCaseForm_StepsField from '@salesforce/label/c.DigibankCaseForm_StepsField';
import DigibankCaseForm_ExpectedField from '@salesforce/label/c.DigibankCaseForm_ExpectedField';
import DigibankCaseForm_ActualField from '@salesforce/label/c.DigibankCaseForm_ActualField';
import DigibankCaseForm_ModalField from '@salesforce/label/c.DigibankCaseForm_ModalField';
import DigibankCaseForm_ModalFieldHelp from '@salesforce/label/c.DigibankCaseForm_ModalFieldHelp';
import DigibankCaseForm_OSField from '@salesforce/label/c.DigibankCaseForm_OSField';
import DigibankCaseForm_PhoneVersionField from '@salesforce/label/c.DigibankCaseForm_PhoneVersionField';
import DigibankCaseForm_VerField from '@salesforce/label/c.DigibankCaseForm_VerField';
import DigibankCaseForm_FileField from '@salesforce/label/c.DigibankCaseForm_FileField';
import DigibankCaseForm_SubmitButton from '@salesforce/label/c.DigibankCaseForm_SubmitButton';
import DigibankCaseForm_SubjectFieldHelp from '@salesforce/label/c.DigibankCaseForm_SubjectFieldHelp';
import DigibankCaseForm_StepsFieldHelp from '@salesforce/label/c.DigibankCaseForm_StepsFieldHelp';
import DigibankCaseForm_IssueFieldHelp from '@salesforce/label/c.DigibankCaseForm_IssueFieldHelp';
import DigibankCaseForm_ExpectedFieldHelp from '@salesforce/label/c.DigibankCaseForm_ExpectedFieldHelp';
import DigibankCaseForm_ActualFieldHelp from '@salesforce/label/c.DigibankCaseForm_ActualFieldHelp';



export default class DigibankCaseForm extends LightningElement {
    showForm = true;
    loaded = false;

    //labels
    title = DigibankCaseForm_Title;
    title_thankYou = DigibankCaseForm_Thankyou;
    emailFieldLabel = DigibankCaseForm_EmailField;
    subjectFieldLabel = DigibankCaseForm_SubjectField;
    subjectFieldHelp = DigibankCaseForm_SubjectFieldHelp;
    issueExprencingFieldLabel = DigibankCaseForm_IssueField;
    issueExprencingFieldHelp = DigibankCaseForm_IssueFieldHelp
    occurenceTimeFieldLabel = DigibankCaseForm_OccurenceField;
    setpsToRepFieldLabel = DigibankCaseForm_StepsField;
    setpsToRepFieldHelp = DigibankCaseForm_StepsFieldHelp;
    expectedResultFieldLabel = DigibankCaseForm_ExpectedField;
    expectedResultFieldHelp = DigibankCaseForm_ExpectedFieldHelp;
    actualResultFieldLabel = DigibankCaseForm_ActualField;
    actualResultFieldHelp = DigibankCaseForm_ActualFieldHelp;
    mobileModalFieldLable = DigibankCaseForm_ModalField;
    mobileModalFieldHelp = DigibankCaseForm_ModalFieldHelp;
    mobileOsFieldLabel = DigibankCaseForm_OSField;
    mobileOsVersionFieldLable = DigibankCaseForm_PhoneVersionField;
    appVerFieldLabel = DigibankCaseForm_VerField;
    fileUploadFieldLabel = DigibankCaseForm_FileField;
    submitButtonLabel = DigibankCaseForm_SubmitButton;

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

            this.phoneOsVersionMasterOptions = data.picklistFieldValues.OS_Version__c;

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
            height:90px;
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

        console.log(d.toISOString())
        console.log(d.getTimezoneOffset())
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
            caseObject.OS_Version__c = this.phoneVersion;
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