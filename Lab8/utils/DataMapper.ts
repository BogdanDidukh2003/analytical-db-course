import { DataMapper } from "@aws/dynamodb-data-mapper";
import { DynamoDB } from "aws-sdk";
import { ProjectConstants } from "../constants/ProjectConstants";


export const dataMapper = new DataMapper({
    client: new DynamoDB({
        region: ProjectConstants.REGION
    }),
});
