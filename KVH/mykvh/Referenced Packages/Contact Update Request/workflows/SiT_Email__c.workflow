<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SiT_Email_Alert</fullName>
        <description>SiT Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>To__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SiT/SiT_Email_Template</template>
    </alerts>
</Workflow>
