name: eShopOnWeb Build and Test

Triggers
- '*'

#Environment variables https://docs.github.com/en/actions/learn-github-actions/environment-variables
env:
  RESOURCE-GROUP: RG1
  LOCATION: eastus
  TEMPLATE-FILE: /scipt.bicep
  SUBSCRIPTION-ID: 'bb4195e0-db09-4dff-a647-9cb334270aec'
  WEBAPP-NAME: az400-webapp-NAME

        
   #Login in your azure subscription using a service principal (credentials stored as GitHub Secret in repo)
- name: Azure Login
    uses: azure/login@v1
     with:
       creds: ${{ secrets.AZURE_CREDENTIALS }}
           
    # Deploy Azure WebApp using Bicep file
- name: deploy
    uses: azure/arm-deploy@v1
    with:
      subscriptionId: ${{ env.SUBSCRIPTION-ID }}
      resourceGroupName: ${{ env.RESOURCE-GROUP }}
      template: /script.bicep
      failOnStdErr: false   
    
   
