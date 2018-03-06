using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour {
    private AudioSource source;

    public static SoundManager Instance;

	void Start () {
        Instance = this;
        source = GetComponent<AudioSource>();
	}
    
    public void TestSound(AudioClip Sound)
    {
        source.PlayOneShot(Sound, 1);
    }
}
