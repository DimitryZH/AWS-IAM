aws iam create-user --user-name yeemin
aws iam create-user --user-name alicia

aws iam create-login-profile --user-name yeemin --password pcgUser#1 --no-password-reset-required
aws iam create-login-profile --user-name alicia --password pcgUser#2 --no-password-reset-required

aws iam create-group —group-name pcg-experts
aws iam add-user-to-group --user-name yeemin --group-name pcg-experts
aws iam add-user-to-group --user-name alicia --group-name pcg-experts
