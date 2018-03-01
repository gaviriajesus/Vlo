<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>One_Time_Margin_to_One_Time_Margin</fullName>
        <field>One_Time_Margin_p__c</field>
        <formula>One_Time_Margin_fp__c</formula>
        <name>One Time Margin to One Time Margin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recurring_Margin_to_Recurring_Margin</fullName>
        <field>Recurring_Margin_p__c</field>
        <formula>Recurring_Margin_fp__c</formula>
        <name>Recurring Margin to Recurring Margin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>vlocity_cmt__AssetRefIdForQLIUpdate</fullName>
        <field>vlocity_cmt__AssetReferenceId__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>AssetRefIdForQLIUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Move Margins</fullName>
        <actions>
            <name>One_Time_Margin_to_One_Time_Margin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Recurring_Margin_to_Recurring_Margin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>VDO: Moves the margin calculations to a Percent filed so can be used in Rollup Summary fields.</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>vlocity_cmt__AssetRefIdForQLI</fullName>
        <actions>
            <name>vlocity_cmt__AssetRefIdForQLIUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$Setup.vlocity_cmt__RunTriggerAndWorkFlow__c.vlocity_cmt__AllowWorkflow__c &amp;&amp; ( LOWER(vlocity_cmt__ProvisioningStatus__c) == &apos;new&apos; || LOWER(vlocity_cmt__ProvisioningStatus__c) == &apos;pendinginsert&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
