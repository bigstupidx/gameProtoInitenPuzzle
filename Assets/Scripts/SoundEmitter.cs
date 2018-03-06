using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundEmitter : MonoBehaviour {
    public Material Mat;

    private AudioSource source;
    private Transform tf;
    private float portee;

    private void Start()
    {
        source = GetComponent<AudioSource>();
        tf = transform;
        portee = GetComponent<SphereCollider>().radius;
        source.maxDistance = portee;
    }

    public void SetMaterial(Material m)
    {
        transform.GetChild(0).GetChild(0).GetComponent<MeshRenderer>().material = m;
        GetComponent<MeshRenderer>().enabled = false;
    }

    public Vector3 GetPosition()
    {
        return tf.position;
    }

    public bool CanReachPlayer()
    {
        float distance = Vector3.Distance(tf.position, Player.Instance.GetPosition());

        var hits = Physics.RaycastAll(tf.position, (Player.Instance.GetPosition() - tf.position).normalized, distance);
        bool canReach = true;

        foreach (var hit in hits)
        {
            if (hit.collider.CompareTag("Wall"))
            {
                canReach = false;
                break;
            }
        }

        return canReach && (distance <= portee);
    }

    public void PlaySound(AudioClip Sound, bool IsClosestToPlayer)
    {
        if (IsClosestToPlayer)
        {
            float distance = Vector3.Distance(tf.position, Player.Instance.GetPosition());

            if (distance <= portee)
            {
                var hits = Physics.RaycastAll(tf.position, (Player.Instance.GetPosition() - tf.position).normalized, distance);
                bool canPlaySound = true;

                foreach (var hit in hits)
                {
                    if (hit.collider.CompareTag("Wall"))
                    {
                        canPlaySound = false;
                        break;
                    }
                }

                if (canPlaySound)
                {
                    source.PlayOneShot(Sound);
                    Player.Instance.CanHearSound(true);
                    Player.Instance.SetDestination(tf.position);
                } else
                {
                    Player.Instance.CanHearSound(false);
                }
            }
        }

        var others = Physics.OverlapSphere(tf.position, portee);

        foreach(var other in others)
        {
            if(other.CompareTag("Animal"))
            {
                var hits = Physics.RaycastAll(tf.position, (other.transform.position - tf.position).normalized, Vector3.Distance(tf.position, other.transform.position));
                bool canPlaySound = true;

                foreach (var hit in hits)
                {
                    if (hit.collider.CompareTag("Wall"))
                    {
                        canPlaySound = false;
                        break;
                    }
                }

                if (canPlaySound)
                {
                    other.GetComponent<Animal>().SetDestination(tf.position);
                }
            }
        }
    }
}
