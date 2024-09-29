
module.exports.readVersion = function (contents) {
    // for config.xcconfig
    let match = contents.match(/app_version = (.+)/);
    if(match){
        return match[1];
    }
    
    // for xxx.podspec
    // (虽然在 .versionrc -> packageFiles 中没有指定xxx.podspec，
    // 但在 .versionrc -> bumpFiles 中指定了xxx.podspec，仍然会对xxx.podspec调readVersion()，
    // 而且必须能正确读出version，否则报错)
    let match2 = contents.match(/s\.version(\s*)=(\s*)'(.+)'/);
    if(match2){
        return match2[3];
    }
}

module.exports.writeVersion = function (contents, version) {
    // 1.0.0-beta.2 -> 1.0.0.2 or
    // 1.0.0-2 -> 1.0.0.2
    const v = version.replace(/-(beta.)*/, '.');
    
    // for config.xcconfig
    let match1 = contents.match(/app_version = (.+)/);
    if(match1){
        return contents.replace(/app_version = (.+)/, `app_version = ${v}`).replace(/app_build = (.+)/, `app_build = ${v}`);
    }
    
    // for xxx.podspec
    let match2 = contents.match(/s\.version(\s*)=(\s*)'(.+)'/);
    if(match2){
        let m0 = match2[0].replace(match2[3], v);
        return contents.replace(match2[0], m0);
    }
}
