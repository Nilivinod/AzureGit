// import { LightningElement,wire } from 'lwc';
// import totalAccountData from '@salesforce/apex/GetAccountData.allAccountData'
// const coloums =[
//     {label: 'Id', fieldName: 'Id'},
//     {label: 'Name', fieldName: 'Name'},
//     {label: 'Phone', fieldName: 'Phone'},
//     {label: 'Rating', fieldName: 'Rating'}
// ];
// export default class ShowAccounytData extends LightningElement {
// coloumslist = coloums;
// dalist = []
// // @wire(totalAccountData)
// // wiredata({error,data}){
// // if(data){
// //     this.dalist=data;
// //     console.log('Data',data)
// // }else if(error){
// // console.log('Error',error);
// // }
// // }
// handleclick(){
// totalAccountData()
// .then((data)=>{
//     this.dalist = data;
// })
// .catch((error)=>{
//     console.error('show me error', error);
// })
// }
// }
import { LightningElement, track } from 'lwc';
import totalAccountData from '@salesforce/apex/GetAccountData.allAccountData';

// Define the columns for the datatable
const coloums = [
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone' },
    { label: 'Rating', fieldName: 'Rating' }
];

export default class ShowAccountData extends LightningElement {
    coloumslist = coloums; // Columns for the datatable
    @track dalist = []; // Data for the datatable
    @track isDataVisible = false; // Tracks whether the datatable is visible

    // Method to handle "Show Data" button click
    handleShowData() {
        totalAccountData()
            .then((data) => {
                this.dalist = data; // Populate the datatable with data
                this.isDataVisible = true; // Show the datatable
                console.log('Data:', data);
            })
            .catch((error) => {
                console.error('Error fetching data:', error);
            });
    }

    // Method to handle "Close Data" button click
    handleCloseData() {
        this.dalist = []; // Clear the datatable data
        this.isDataVisible = false; // Hide the datatable
    }
}