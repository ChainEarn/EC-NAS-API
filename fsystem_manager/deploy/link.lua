module(..., package.seeall)

OWN_POOL = {
    redis = {
    },
    mysql = {

        omstor___omstor_db = {
            host = '127.0.0.1',
            port = 3306,
            database = 'omstor_db',
            user = 'omstor',
            password ='123456',
        },

    },
}


OWN_DIED = {
    redis = {
    },
    mysql = {
    },

}


setmetatable(_M, { __index = _M })
