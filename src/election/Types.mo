module {

    public type ApiError = {
        #InvalidOption;
        #AlreadyVoted;
    };

    public type Result<S, E> = {
        #Ok : S;
        #Err : E;
    };

    public type VoteResult = Result<Text, ApiError>;
};